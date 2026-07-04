# custom — Hyprland theme & tooling

Temas **theme-prateado**, **theme-everforest**, **theme-gruvbox**, **theme-glass**, **theme-orange**, **theme-sonokai**, **theme-edge** e **theme-bamboo** para Waybar, Rofi, Foot e Hyprland.

## Preview

### theme-prateado

![theme-prateado](previews/prateado.jpg)

### theme-everforest

![theme-everforest](previews/everforest.jpg)

### theme-gruvbox

![theme-gruvbox](previews/gruvbox.jpg)

### theme-glass

![theme-glass](previews/glass.jpg)

### theme-orange

![theme-orange](previews/orange.jpg)

### theme-sonokai

![theme-sonokai](previews/sonokai.jpg)

### theme-edge

![theme-edge](previews/edge.jpg)

### theme-bamboo

![theme-bamboo](previews/bamboo.jpg)

## Estrutura

```
custom/
├── theme-prateado/
├── theme-everforest/
├── theme-gruvbox/
├── theme-glass/
├── theme-orange/
├── theme-sonokai/
├── theme-edge/
├── theme-bamboo/
│   ├── theme.conf
│   ├── waybar/
│   ├── rofi/
│   └── foot/
└── scripts/
    ├── shot.sh
    └── rofi-theme.sh

hypr/
├── hyprland.conf
├── binds.conf
├── current_theme.conf
├── windows-rule.conf
├── hypridle.conf
├── hyprsunset.conf
└── hyprlock.conf

current                  # tema ativo ($THEME)
waybar-current.sh        # exec-once → waybar do tema em current
install.sh               # instala ~/.config/custom
install_hypr.sh          # instala ~/.config/hypr
```

## Instalação

```bash
git clone git@github.com:amonetlol/custom.git
cd custom
./install.sh
./install_hypr.sh
```

O `hyprland.conf` já inclui:

```conf
source = ~/.config/hypr/current_theme.conf
source = ~/.config/hypr/windows-rule.conf
source = ~/.config/hypr/binds.conf
```

Trocar tema: **Super+T** (`rofi-theme.sh`) ou editar `~/.config/custom/current`.

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

## Atalhos (`hypr/binds.conf`)

| Atalho | Ação |
|--------|------|
| Super+D | Launcher |
| Super+F2 | Hub GUI |
| Super+F11 | Hub GUI |
| Super+F12 | Reiniciar waybar |
| Super+F10 | Wallpaper |
| Super+T | Seletor de tema |
| Super+Shift+C | Configuration (editar configs) |
| Alt+V | Clipboard |
| Super+X | Power menu |
| Super+Shift+D | Window switcher |
| Super+Shift+R | `hyprctl reload` |
| Super+Return | Foot |
| Super+Shift+Return | Foot flutuante |
| Super+E | Thunar |
| Super+W | Firefox |
| Super+F | Fullscreen |
| Super+Q | Fechar janela |
| Super+P | Screenshot área |
| Print | Screenshot tela |
| Super+Print | Screenshot área |
| Super+1–0 | Workspaces |
| Super+Shift+1–0 | Mover janela para workspace |

## Dependências

- hyprland, waybar, rofi, foot, awww, wttrbar
- cliphist, wl-clipboard, pamixer ou wpctl
- hyprlock, brightnessctl (opcional)
