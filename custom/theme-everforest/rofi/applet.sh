#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$ROFI_DIR/applet.rasi"
HUB="$HOME/.config/custom/theme-everforest/rofi/hub.sh"

options=$'Wi-Fi\nBluetooth\nÁudio\nBrilho\nWallpaper\nClipboard\nJanelas\nPower menu'

run_action() {
  case "$1" in
    Wi-Fi)       command -v nm-connection-editor >/dev/null && exec nm-connection-editor ;;
    Bluetooth)   command -v blueman-manager >/dev/null && exec blueman-manager ;;
    Áudio)       command -v pavucontrol >/dev/null && exec pavucontrol ;;
    Brilho)      command -v brightnessctl >/dev/null && brightnessctl -e ;;
    Wallpaper)   exec "$HUB" --wall ;;
    Clipboard)   exec "$HUB" --clip ;;
    Janelas)     exec "$HUB" --window ;;
    "Power menu") exec "$HUB" --power ;;
    *)           notify-send -u low "Applet" "Opção desconhecida: $1" 2>/dev/null || true ;;
  esac
}

chosen="$(printf '%s\n' "$options" | rofi -dmenu -i -p "System" -theme "$THEME")"
[[ -z "${chosen:-}" ]] && exit 0
run_action "$chosen"
