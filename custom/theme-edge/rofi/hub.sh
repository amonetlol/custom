#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="${HOME}/.config/custom/theme-edge"
ROFI_DIR="$THEME_DIR/rofi"
WAYBAR_DIR="$THEME_DIR/waybar"
FOOT_INI="$THEME_DIR/foot/foot.ini"
IDLE_PID_FILE="${XDG_RUNTIME_DIR:-/tmp}/theme-edge-idle-inhibit.pid"

usage() {
  cat <<EOF
Usage: $(basename "$0") <flag>

Hub theme-edge:
  --menu        Application launcher (drun)
  --applet      System applet menu
  --clip        Clipboard history
  --wall        Wallpaper picker (awww)
  --power       Power menu
  --window      Window switcher
  --foot        Launch foot terminal
  --waybar      Restart waybar
  --idle-on     Keep display awake (idle inhibitor helper)
  --idle-off    Stop idle inhibitor helper
EOF
  exit 1
}

[[ $# -eq 1 ]] || usage

chmod +x "$ROFI_DIR"/*.sh 2>/dev/null || true

case "$1" in
  --menu)
    exec "$ROFI_DIR/launcher.sh"
    ;;
  --applet)
    exec "$ROFI_DIR/applet.sh"
    ;;
  --clip)
    exec "$ROFI_DIR/cliphist.sh"
    ;;
  --wall)
    exec "$ROFI_DIR/wallpaper.sh"
    ;;
  --power)
    exec "$ROFI_DIR/powermenu.sh"
    ;;
  --window)
    exec "$ROFI_DIR/window.sh"
    ;;
  --foot)
    exec foot -c "$FOOT_INI"
    ;;
  --waybar)
    exec "${HOME}/.config/custom/waybar-current.sh"
    ;;
  --idle-on)
    if [[ -f "$IDLE_PID_FILE" ]] && kill -0 "$(cat "$IDLE_PID_FILE")" 2>/dev/null; then
      exit 0
    fi
    if command -v systemd-inhibit >/dev/null; then
      systemd-inhibit --what=idle:sleep --who=theme-edge --why="stay awake" \
        sleep infinity &
      echo $! >"$IDLE_PID_FILE"
      notify-send -u low "Idle" "Inhibitor ativo" 2>/dev/null || true
    else
      notify-send -u low "Idle" "systemd-inhibit não encontrado" 2>/dev/null || true
      exit 1
    fi
    ;;
  --idle-off)
    if [[ -f "$IDLE_PID_FILE" ]]; then
      kill "$(cat "$IDLE_PID_FILE")" 2>/dev/null || true
      rm -f "$IDLE_PID_FILE"
    fi
    ;;
  *)
    usage
    ;;
esac
