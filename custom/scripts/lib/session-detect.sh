#!/usr/bin/env bash

hypr_config_dir() {
  if pgrep -af "Hyprland|start-hyprland" | grep -Fq -- "--config ${HOME}/.config/hyprtheme/"; then
    echo "$HOME/.config/hyprtheme"
  else
    echo "$HOME/.config/hypr"
  fi
}

custom_theme_dir() {
  local custom_dir="${CUSTOM_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/custom}"
  local current="$custom_dir/current"
  local theme

  [[ -f "$current" ]] || return 1
  theme="$(grep -E '^\$THEME\s*=' "$current" | head -1 | sed -E 's/^\$THEME\s*=\s*//;s/[[:space:]]*$//')"
  [[ -n "$theme" ]] || return 1
  printf '%s/%s' "$custom_dir" "$theme"
}

foot_nvim() {
  local custom_dir="${CUSTOM_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/custom}"
  foot -c "$custom_dir/foot/foot.ini" nvim "$@"
}
