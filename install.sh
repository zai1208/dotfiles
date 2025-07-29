#!/bin/bash

dotfiles_dir=~/dotfiles

# Symlink .config
ln -sf $dotfiles_dir/.config ~/.config

# Copy Wallpapers
mkdir -p ~/wallpapers
cp -r $dotfiles_dir/wallpapers/* ~/wallpapers/

echo "[*] Dotfiles deployment done. Ensure hyprland.conf has:"
echo "    exec-once = swww init && swww img ~/wallpapers/endeavouros_gemini.png"
