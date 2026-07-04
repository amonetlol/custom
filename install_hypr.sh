#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/hypr"
DEST="${XDG_CONFIG_HOME:-$HOME}/.config/hypr"
BACKUP="${DEST}.bkp"

[[ -d "$SRC" ]] || {
  echo "→ Pasta não encontrada: $SRC" >&2
  exit 1
}

if [[ -d "$DEST" ]]; then
  echo "→ Backup: $DEST → $BACKUP"
  rm -rf "$BACKUP"
  mv "$DEST" "$BACKUP"
fi

echo "→ Instalando em $DEST"
mkdir -p "$DEST"
cp -a "$SRC/." "$DEST/"

# Restaura auxiliares do backup (hypridle, scripts, etc.)
if [[ -d "$BACKUP" ]]; then
  for item in hypridle.conf hyprlock.conf hyprsunset.conf scripts .format; do
    if [[ ! -e "$DEST/$item" && -e "$BACKUP/$item" ]]; then
      cp -a "$BACKUP/$item" "$DEST/$item"
      echo "  ↳ restaurado: $item"
    fi
  done
fi

cat <<EOF

Instalação Hypr concluída.

Arquivos gerenciados:
  ~/.config/hypr/hyprland.conf
  ~/.config/hypr/binds.conf
  ~/.config/hypr/current_theme.conf
  ~/.config/hypr/windows-rule.conf

Reinicie o Hyprland ou execute: hyprctl reload

EOF
