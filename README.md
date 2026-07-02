# custom — Hyprland theme & tooling

Paleta monocromática **theme-prateado** para Waybar, Rofi, Foot e Hyprland.

## Preview

![theme-prateado](previews/prateado.jpg)

## Estrutura

```
custom/
├── theme-prateado/
│   ├── theme.conf          # cores/decoração Hyprland
│   ├── waybar/             # barra superior (config, style, colors)
│   ├── rofi/               # menus (launcher, hub, wallpaper, etc.)
│   └── foot/               # terminal
└── scripts/
    └── shot.sh             # screenshots

binds.conf                  # atalhos → hub/rofi
current_theme.conf          # source do tema ativo
install.sh                  # copia tudo para ~/.config/custom
```

## Instalação

```bash
git clone git@github.com:amonetlol/custom.git
cd custom
./install.sh
```

No `hyprland.conf`:

```conf
source = ~/.config/custom/current_theme.conf
source = ~/.config/custom/binds.conf
```

## Hub (`rofi/hub.sh`)

Dispatcher central dos menus:

| Flag | Ação |
|------|------|
| `--menu` | Launcher (drun) |
| `--applet` | Menu sistema |
| `--clip` | Clipboard |
| `--wall` | Wallpaper (awww) |
| `--power` | Power menu |
| `--window` | Window switcher |
| `--foot` | Terminal foot |
| `--waybar` | Reinicia waybar |

## Hub GUI (`rofi/hub-gui.sh`)

Menu Rofi com nomes legíveis para as ações do hub.

## Atalhos (`binds.conf`)

| Atalho | Ação |
|--------|------|
| Super+D | Launcher |
| Super+F11 | Hub GUI |
| Super+F12 | Reiniciar waybar |
| Super+F10 | Wallpaper |
| Alt+V | Clipboard |
| Alt+X | Power menu |
| Super+Shift+D | Window switcher |
| Super+Shift+R | `hyprctl reload` |
| Super+Return | Foot |
| Super+Shift+Return | Foot flutuante |
| Super+E | Thunar |
| Super+W | Firefox |
| Super+F | Fullscreen |
| Print | Screenshot tela |
| Super+Print | Screenshot área |

## Dependências

- hyprland, waybar, rofi, foot, awww, wttrbar
- cliphist, wl-clipboard, pamixer ou wpctl
- hyprlock, brightnessctl (opcional)
