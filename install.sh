#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/custom"

echo "→ Instalando em $DEST"
mkdir -p "$DEST"
cp -a "$ROOT/custom/." "$DEST/"
cp "$ROOT/binds.conf" "$ROOT/current_theme.conf" "$DEST/"

find "$DEST" -type f -name '*.sh' -exec chmod +x {} \;

cat <<EOF

Instalação concluída.

No hyprland.conf (hyprtheme ou hypr), adicione:

  source = ~/.config/custom/current_theme.conf
  source = ~/.config/custom/binds.conf

Reinicie o Hyprland ou execute: hyprctl reload

EOF
