#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CUSTOM_DIR="${CUSTOM_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/custom}"
ROFI_THEME="$SCRIPT_DIR/configuration.rasi"

# shellcheck source=lib/session-detect.sh
source "$SCRIPT_DIR/lib/session-detect.sh"

if [[ $# -gt 2 || ( $# -ge 1 && "$1" != "standalone" && "$1" != "menu" ) ]]; then
  echo "Usage: $0 [menu|standalone] [previous_menu]"
  exit 1
fi

THEME_DIR="$(custom_theme_dir || true)"

options=$(printf " Hyprland\n Scripts\n Waybar\n Rofi\n Foot\n Mako\n Wallpapers\n Neovim" \
  | rofi -i -dmenu -p " Configuration" -theme "$ROFI_THEME") || {
  notify-send -u critical "Configuration" "Falha ao abrir o menu (rofi)." 2>/dev/null || true
  exit 1
}

[[ -z "$options" ]] && exit 0

open_dir() {
  foot_nvim "$1"
}

case "$options" in
  *Hyprland*) open_dir "$(hypr_config_dir)" ;;
  *Scripts*) open_dir "$CUSTOM_DIR/scripts" ;;
  *Waybar*)
    [[ -n "$THEME_DIR" ]] || { notify-send -u critical "Configuration" "Tema ativo não encontrado." 2>/dev/null; exit 1; }
    open_dir "$THEME_DIR/waybar"
    ;;
  *Rofi*)
    [[ -n "$THEME_DIR" ]] || { notify-send -u critical "Configuration" "Tema ativo não encontrado." 2>/dev/null; exit 1; }
    open_dir "$THEME_DIR/rofi"
    ;;
  *Foot*)
    [[ -n "$THEME_DIR" ]] || { notify-send -u critical "Configuration" "Tema ativo não encontrado." 2>/dev/null; exit 1; }
    open_dir "$THEME_DIR/foot"
    ;;
  *Mako*)
    [[ -n "$THEME_DIR" ]] || { notify-send -u critical "Configuration" "Tema ativo não encontrado." 2>/dev/null; exit 1; }
    open_dir "$THEME_DIR/mako"
    ;;
  *Wallpapers*) open_dir "$HOME/Imagens/wallpapers" ;;
  *Neovim*)
    foot_nvim +'lua Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath("config") })' 2>/dev/null \
      || foot_nvim "$HOME/.config/nvim"
    ;;
  *)
    notify-send -u normal "Configuration" "Opção desconhecida." 2>/dev/null || true
    ;;
esac
