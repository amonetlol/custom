#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUB="$ROFI_DIR/hub.sh"
THEME="$ROFI_DIR/hub-gui.rasi"

declare -A ACTIONS=(
  [Rofi]="--menu"
  [Window]="--window"
  [Clipboard]="--clip"
  [Wallpaper]="--wall"
  [Power menu]="--power"
  [Foot]="--foot"
  [Waybar]="--waybar"
)

OPTIONS=$'Rofi\nWindow\nClipboard\nWallpaper\nPower menu\nFoot\nWaybar'

chosen="$(printf '%s\n' "$OPTIONS" | rofi -dmenu -i -p "Hub" -theme "$THEME")"
[[ -z "${chosen:-}" ]] && exit 0

chosen="$(printf '%s' "$chosen" | sed 's/<[^>]*>//g; s/^[[:space:]]*//; s/[[:space:]]*$//')"
flag="${ACTIONS[$chosen]:-}"

if [[ -z "$flag" ]]; then
  notify-send -u low "Hub" "Opção desconhecida: $chosen" 2>/dev/null || true
  exit 1
fi

exec "$HUB" "$flag"
