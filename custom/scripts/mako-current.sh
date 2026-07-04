#!/usr/bin/env bash
set -euo pipefail

CUSTOM_DIR="${CUSTOM_DIR:-${XDG_CONFIG_HOME:-$HOME}/.config}/custom}"
CURRENT="$CUSTOM_DIR/current"

theme="${1:-}"
if [[ -z "$theme" ]]; then
  [[ -f "$CURRENT" ]] || exit 1
  theme="$(grep -E '^\$THEME\s*=' "$CURRENT" | head -1 | sed -E 's/^\$THEME\s*=\s*//;s/[[:space:]]*$//')"
fi

[[ -n "$theme" ]] || exit 1

cfg="$CUSTOM_DIR/$theme/mako/config"
[[ -f "$cfg" ]] || {
  echo "mako-current: config não encontrado: $cfg" >&2
  exit 1
}

pkill -x mako 2>/dev/null || true
pkill -f 'mako -c' 2>/dev/null || true

for _ in $(seq 1 20); do
  pgrep -x mako >/dev/null || break
  sleep 0.05
done

if pgrep -x mako >/dev/null; then
  pkill -9 -x mako 2>/dev/null || true
  pkill -9 -f 'mako -c' 2>/dev/null || true
  sleep 0.1
fi

nohup mako -c "$cfg" >/dev/null 2>&1 &
disown -h "$!" 2>/dev/null || true
