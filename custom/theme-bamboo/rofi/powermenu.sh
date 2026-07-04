#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$ROFI_DIR/powermenu.rasi"

die() { printf "[ERRO] %s\n" "$1" >&2; exit 1; }
warn() { printf "[AVISO] %s\n" "$1"; }

prompt="$(hostname) (Hyprland)"
mesg="Uptime: $(uptime -p | sed 's/up //g')"

options=$'Lock\nLogout\nSuspend\nReboot\nShutdown'

ensure_hypr_env() {
  export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
  if [[ -z "${HYPRLAND_INSTANCE_SIGNATURE:-}" && -d "$XDG_RUNTIME_DIR/hypr" ]]; then
    HYPRLAND_INSTANCE_SIGNATURE="$(ls "$XDG_RUNTIME_DIR/hypr" 2>/dev/null | head -1)"
    export HYPRLAND_INSTANCE_SIGNATURE
  fi
}

hyprland_running() {
  ensure_hypr_env
  [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]] && command -v hyprctl >/dev/null
}

do_logout() {
  if hyprland_running; then
    hyprctl dispatch exit 2>/dev/null && return 0
    hyprctl kill 2>/dev/null && return 0
    pkill -x Hyprland 2>/dev/null && return 0
    warn "hyprctl exit falhou — tentando loginctl"
  fi
  if [[ -n "${XDG_SESSION_ID:-}" ]]; then
    loginctl terminate-session "$XDG_SESSION_ID" --no-ask-password
    return 0
  fi
  loginctl terminate-user "$USER" --no-ask-password
}

locky() {
  if command -v hyprlock >/dev/null; then
    hyprlock
  elif command -v swaylock >/dev/null; then
    swaylock
  else
    die "Nenhum locker encontrado (hyprlock/swaylock)"
  fi
}

run_cmd() {
  case "$1" in
    lock)      locky ;;
    logout)    do_logout ;;
    suspend)   systemctl suspend ;;
    reboot)    systemctl reboot ;;
    shutdown)  systemctl poweroff ;;
    *)         return 1 ;;
  esac
}

chosen="$(printf '%s\n' "$options" | rofi -dmenu -p "$prompt" -mesg "$mesg" -theme "$THEME")"
[[ -z "${chosen:-}" ]] && exit 0
chosen="$(printf '%s' "$chosen" | sed 's/<[^>]*>//g; s/^[[:space:]]*//; s/[[:space:]]*$//')"

case "$chosen" in
  Lock)      run_cmd lock ;;
  Logout)    run_cmd logout ;;
  Suspend)   run_cmd suspend ;;
  Reboot)    run_cmd reboot ;;
  Shutdown)  run_cmd shutdown ;;
  *)
    case "$chosen" in
      *Lock*)              run_cmd lock ;;
      *Logout*|*Sair*)     run_cmd logout ;;
      *Suspend*)           run_cmd suspend ;;
      *Reboot*|*Reiniciar*) run_cmd reboot ;;
      *Shutdown*|*Desligar*) run_cmd shutdown ;;
    esac
    ;;
esac
