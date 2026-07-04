#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/custom"

echo "→ Instalando em $DEST"
mkdir -p "$DEST"
cp -a "$ROOT/custom/." "$DEST/"
cp "$ROOT/current" "$ROOT/waybar-current.sh" "$DEST/"

find "$DEST" -type f -name '*.sh' -exec chmod +x {} \;

cat <<EOF

Instalação concluída.

Temas (custom):
  ./install.sh

Hyprland (hyprland.conf, binds, window rules):
  ./install_hypr.sh

Reinicie o Hyprland ou execute: hyprctl reload

EOF
