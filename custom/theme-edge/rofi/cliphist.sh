#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME="$ROFI_DIR/cliphist.rasi"

if ! cliphist list &>/dev/null; then
  printf 'clipboard-init' | cliphist store 2>/dev/null || true
fi

exec rofi -modi "clipboard:$ROFI_DIR/cliphist-img.sh" -show clipboard -theme "$THEME"
