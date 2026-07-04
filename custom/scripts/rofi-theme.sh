#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_DIR="${CUSTOM_DIR:-$HOME/.config/custom}"
CURRENT_FILE="$CUSTOM_DIR/current"
THEME_RASI="$SCRIPTS_DIR/rofi-theme.rasi"
SHARED_LINK="$SCRIPTS_DIR/rofi-theme-shared"
FOOT_LINK="$CUSTOM_DIR/foot"
MAKO_LINK="$CUSTOM_DIR/mako"

list_themes() {
  grep -E '^\s*#?\s*\$THEME\s*=' "$CURRENT_FILE" \
    | sed -E 's/^\s*#?\s*\$THEME\s*=\s*//;s/[[:space:]]*$//'
}

get_active_theme() {
  grep -E '^\$THEME\s*=' "$CURRENT_FILE" \
    | head -1 \
    | sed -E 's/^\$THEME\s*=\s*//;s/[[:space:]]*$//'
}

theme_label() {
  local id="$1"
  local name="${id#theme-}"
  printf '%s' "${name^}"
}

theme_id_from_label() {
  local label="$1"
  local theme
  while IFS= read -r theme; do
    [[ -z "$theme" ]] && continue
    if [[ "$(theme_label "$theme")" == "$label" ]]; then
      printf '%s' "$theme"
      return 0
    fi
  done < <(list_themes)
  return 1
}

link_shared() {
  local theme="$1"
  local shared="$CUSTOM_DIR/$theme/rofi/shared"
  [[ -d "$shared" ]] || {
    notify-send -u critical "Tema" "Pasta não encontrada: $shared" 2>/dev/null || true
    exit 1
  }
  ln -sfn "$shared" "$SHARED_LINK"
}

link_foot() {
  local theme="$1"
  local foot_dir="$CUSTOM_DIR/$theme/foot"
  [[ -d "$foot_dir" ]] || {
    notify-send -u critical "Tema" "Pasta não encontrada: $foot_dir" 2>/dev/null || true
    exit 1
  }
  ln -sfn "$foot_dir" "$FOOT_LINK"
}

link_mako() {
  local theme="$1"
  local mako_dir="$CUSTOM_DIR/$theme/mako"
  [[ -d "$mako_dir" ]] || {
    notify-send -u critical "Tema" "Pasta não encontrada: $mako_dir" 2>/dev/null || true
    exit 1
  }
  rm -rf "$MAKO_LINK"
  ln -sfn "$mako_dir" "$MAKO_LINK"
}

reload_foot() {
  if command -v footclient >/dev/null 2>&1; then
    footclient reload 2>/dev/null || true
  fi
  pkill -USR1 -x foot 2>/dev/null || true
}

reload_mako() {
  pkill -x mako 2>/dev/null || true
  sleep 0.1
  if [[ -f "$MAKO_LINK/config" ]]; then
    mako -c "$MAKO_LINK/config" &
  fi
}

apply_theme() {
  local selected="$1"
  local themes=()
  mapfile -t themes < <(list_themes)

  {
    echo "# Tema ativo — descomente apenas um \$THEME"
    for t in "${themes[@]}"; do
      if [[ "$t" == "$selected" ]]; then
        echo "\$THEME = $t"
      else
        echo "# \$THEME = $t"
      fi
    done
  } >"$CURRENT_FILE"

  link_shared "$selected"
  link_foot "$selected"
  link_mako "$selected"
  hyprctl reload
  "$CUSTOM_DIR/waybar-current.sh"
  reload_foot
  reload_mako
  notify-send -u low "Tema" "Ativo: $(theme_label "$selected")" 2>/dev/null || true
}

[[ -f "$CURRENT_FILE" ]] || {
  notify-send -u critical "Tema" "Arquivo não encontrado: $CURRENT_FILE" 2>/dev/null || true
  exit 1
}

active="$(get_active_theme)"
link_shared "$active"
link_foot "$active"
link_mako "$active"

menu=""
while IFS= read -r theme; do
  [[ -z "$theme" ]] && continue
  label="$(theme_label "$theme")"
  if [[ "$theme" == "$active" ]]; then
    menu+="● ${label}"$'\n'
  else
    menu+="${label}"$'\n'
  fi
done < <(list_themes)

chosen="$(printf '%s' "$menu" | rofi -dmenu -i -p "Tema" -theme "$THEME_RASI")"
[[ -z "${chosen:-}" ]] && exit 0

chosen="${chosen#● }"
chosen="$(printf '%s' "$chosen" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
[[ -z "$chosen" ]] && exit 0

selected="$(theme_id_from_label "$chosen")"
[[ -z "$selected" ]] && exit 0
[[ "$selected" == "$active" ]] && exit 0

apply_theme "$selected"
