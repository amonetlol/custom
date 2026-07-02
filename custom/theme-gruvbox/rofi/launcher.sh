#!/usr/bin/env bash
set -euo pipefail

ROFI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec rofi -show drun -theme "$ROFI_DIR/launcher.rasi"
