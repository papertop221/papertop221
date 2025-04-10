#!/bin/bash
# Remix Setup: Hyprland + Waybar (Minimalis tapi Fitur Lengkap)
# Pastikan lo pake Arch Linux, punya yay (untuk AUR), dan akses sudo.
# Referensi: Arch Wiki, Hyprland Docs, Waybar GitHub.
# Simpen file ini misalnya: setup-remix-hyprland.sh, terus chmod +x dan jalankan.

set -e

echo "Mulai remixing setup minimalis tapi penuh fitur..."

# Daftar package dari repos resmi
declare -a pacman_packages=(
  "swww"
  "ttf-jetbrains-mono-nerd"
  "noto-fonts-emoji"
)

for pkg in "${pacman_packages[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        echo "Installing $pkg..."
        sudo pacman -S --needed "$pkg" --noconfirm
    else
        echo "$pkg udah terinstall."
    fi
done

# Install Waybar-hyprland dari AUR kalo Waybar belum ada
if ! pacman -Qi waybar &>/dev/null; then
  echo "Waybar gak ketemu di repos, install waybar-hyprland-git dari AUR..."
  if command -v yay &>/dev/null; then
    yay -S --needed waybar-hyprland-git --noconfirm
  else
    echo "Yay belum terinstall! Install yay atau AUR helper lain, terus install 'waybar-hyprland-git' manual."
    exit 1
  fi
else
  echo "Waybar udah terinstall."
fi

# Buat direktori konfigurasi
declare -a config_dirs=(
  "$HOME/.config/hypr"
  "$HOME/.config/waybar"
  "$HOME/.config/wallpapers"
)

for dir in "${config_dirs[@]}"; do
    mkdir -p "$dir"
    echo "Directory verified: $dir"
done

# Buat Hyprland Remix Configuration (Minimalis tapi penuh fitur)
cat > "$HOME/.config/hypr/hyprland.conf" << 'EOF'
# Remix Hyprland Config - Minimalis, Elegan & Fitur Lengkap

# Auto-launch Waybar dan wallpaper
exec-once = waybar &
exec-once = swww init && swww img ~/.config/wallpapers/remix_wallpaper.jpg

monitor=,preferred,auto,1

input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

general {
    gaps_in = 6
    gaps_out = 12
    border_size = 2
    col.active_border = rgba(151,157,165,0.9)
    col.inactive_border = rgba(31,31,31,0.9)
    layout = tile
}

decoration {
    rounding = 6
    blur {
        enabled = true
        size = 8
        passes = 2
        vibrancy = 0.15
    }

}

animations {
    enabled = true
    bezier = soft,0.2,1,0.2,1
    animation = windows,1,7,soft
    animation = fade,1,6,default
    animation = workspaces,1,5,soft
}

# Keybindings Remix - Simple & Powerful

# Launcher
bind = SUPER, RETURN, exec, alacritty
bind = SUPER, D, exec, rofi -show drun

# Close window
bind = SUPER, Q, killactive

# Floating toggle
bind = SUPER, SPACE, togglefloating

# Move focus
bind = SUPER, H, movefocus, l
bind = SUPER, L, movefocus, r
bind = SUPER, K, movefocus, u
bind = SUPER, J, movefocus, d

# Move window
bind = SUPER_SHIFT, H, movewindow, l
bind = SUPER_SHIFT, L, movewindow, r
bind = SUPER_SHIFT, K, movewindow, u
bind = SUPER_SHIFT, J, movewindow, d

# Resize window
bind = SUPER_CTRL, H, resizeactive, -20 0
bind = SUPER_CTRL, L, resizeactive, 20 0
bind = SUPER_CTRL, K, resizeactive, 0 -20
bind = SUPER_CTRL, J, resizeactive, 0 20

# Workspace switching
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5

# Move window to workspace
bind = SUPER_SHIFT, 1, movetoworkspace, 1
bind = SUPER_SHIFT, 2, movetoworkspace, 2
bind = SUPER_SHIFT, 3, movetoworkspace, 3
bind = SUPER_SHIFT, 4, movetoworkspace, 4
bind = SUPER_SHIFT, 5, movetoworkspace, 5
EOF

echo "Hyprland remix config udah dibuat di ~/.config/hypr/hyprland.conf"

# Buat Waybar Remix Configuration (Minimalis & Fitur Lengkap)
cat > "$HOME/.config/waybar/config" << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 28,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["battery", "network", "pulseaudio"],
    "clock": {
         "format": "  {:%H:%M}  "
    },
    "battery": {
         "format": "{capacity}%   "
    },
    "network": {
         "format-wifi": " {essid}  ",
         "format-ethernet": " {ipaddr}  "
    },
    "pulseaudio": {
         "format": " {volume}%  "
    }
}
EOF

echo "Waybar remix config udah dibuat di ~/.config/waybar/config"

# Buat Waybar CSS Style (Monochrome, Minimalis, Elegan)
cat > "$HOME/.config/waybar/style.css" << 'EOF'
* {
    font-family: "JetBrainsMono Nerd Font";
    font-size: 12px;
    color: #b0b0b0;
    background: transparent;
    padding-left: 4px;
    padding-right: 4px;
}
#workspaces button {
    border: 1px solid transparent;
    margin: 2px;
    padding: 2px 5px;
    transition: background 0.2s ease, border 0.2s ease;
}
#workspaces button.active {
    background: #3c3c3c;
    color: #ffffff;
    border: 1px solid #5c5c5c;
}
EOF

echo "Waybar remix style udah dibuat di ~/.config/waybar/style.css"

echo ""
echo "============================================="
echo "Remix setup complete, kawan!"
echo "👉 Pastikan lo taruh wallpaper remix di: ~/.config/wallpapers/remix_wallpaper.jpg"
echo "👉 Restart Hyprland session lo buat ngeliat hasil remix yang keren abis!"
echo "============================================="
