#!/usr/bin/env bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_DIR="${CUSTOM_DIR:-$HOME/.config/custom}"
CURRENT_FILE="$CUSTOM_DIR/current"
THEME_RASI="$SCRIPTS_DIR/rofi-theme.rasi"
SHARED_LINK="$SCRIPTS_DIR/rofi-theme-shared"

list_themes() {
  grep -E '^\s*#?\s*\$THEME\s*=' "$CURRENT_FILE" \
    | sed -E 's/^\s*#?\s*\$THEME\s*=\s*//;s/[[:space:]]*$//'
}

get_active_theme() {
  grep -E '^\$THEME\s*=' "$CURRENT_FILE" \
    | head -1 \
    | sed -E 's/^\$THEME\s*=\s*//;s/[[:space:]]*$//'
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
  hyprctl reload
  "$CUSTOM_DIR/$selected/rofi/hub.sh" --waybar
  notify-send -u low "Tema" "Ativo: $selected" 2>/dev/null || true
}

[[ -f "$CURRENT_FILE" ]] || {
  notify-send -u critical "Tema" "Arquivo não encontrado: $CURRENT_FILE" 2>/dev/null || true
  exit 1
}

active="$(get_active_theme)"
link_shared "$active"

menu=""
while IFS= read -r theme; do
  [[ -z "$theme" ]] && continue
  if [[ "$theme" == "$active" ]]; then
    menu+="● ${theme}"$'\n'
  else
    menu+="${theme}"$'\n'
  fi
done < <(list_themes)

chosen="$(printf '%s' "$menu" | rofi -dmenu -i -p "Tema" -theme "$THEME_RASI")"
[[ -z "${chosen:-}" ]] && exit 0

chosen="${chosen#● }"
chosen="$(printf '%s' "$chosen" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
[[ -z "$chosen" ]] && exit 0
[[ "$chosen" == "$active" ]] && exit 0

apply_theme "$chosen"
