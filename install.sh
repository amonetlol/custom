#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/custom"

echo "→ Instalando em $DEST"
mkdir -p "$DEST"

# Symlink gerenciado pelo tema — remover antes do cp
rm -rf "$DEST/foot"
rm -f "$DEST/scripts/rofi-theme-shared"

cp -a "$ROOT/custom/." "$DEST/"
cp "$ROOT/current" "$ROOT/waybar-current.sh" "$DEST/"

find "$DEST" -type f -name '*.sh' -exec chmod +x {} \;

CURRENT_THEME="$(grep -E '^\$THEME\s*=' "$DEST/current" | head -1 | sed -E 's/^\$THEME\s*=\s*//;s/[[:space:]]*$//')"
if [[ -n "$CURRENT_THEME" && -d "$DEST/$CURRENT_THEME" ]]; then
  ln -sfn "$DEST/$CURRENT_THEME/rofi/shared" "$DEST/scripts/rofi-theme-shared"
  ln -sfn "$DEST/$CURRENT_THEME/foot" "$DEST/foot"
fi

cat <<EOF

Instalação concluída.

Temas (custom):
  ./install.sh

Hyprland (hyprland.conf, binds, window rules):
  ./install_hypr.sh

Reinicie o Hyprland ou execute: hyprctl reload

EOF
