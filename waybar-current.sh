#!/usr/bin/env bash
set -euo pipefail

CUSTOM_DIR="${XDG_CONFIG_HOME:-$HOME}/.config/custom"
CURRENT="$CUSTOM_DIR/current"

[[ -f "$CURRENT" ]] || {
  echo "waybar-current: arquivo não encontrado: $CURRENT" >&2
  exit 1
}

THEME="$(grep -E '^\$THEME\s*=' "$CURRENT" | head -1 | sed -E 's/^\$THEME\s*=\s*//;s/[[:space:]]*$//')"
WAYBAR_DIR="$CUSTOM_DIR/$THEME/waybar"

[[ -f "$WAYBAR_DIR/config.jsonc" && -f "$WAYBAR_DIR/style.css" ]] || {
  echo "waybar-current: waybar não encontrado em $WAYBAR_DIR" >&2
  exit 1
}

pkill waybar 2>/dev/null || true
sleep 0.2
exec waybar -c "$WAYBAR_DIR/config.jsonc" -s "$WAYBAR_DIR/style.css"
