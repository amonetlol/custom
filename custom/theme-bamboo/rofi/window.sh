#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec rofi -show window -theme "$ROFI_DIR/window.rasi"
