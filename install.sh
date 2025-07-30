#!/bin/bash

dotfiles_dir=~/dotfiles

# Symlink .config
ln -sf $dotfiles_dir/.config ~/.config

# Symlink wallpapers directory
ln -sf $dotfiles_dir/wallpapers ~/wallpapers/

echo "[*] Dotfiles deployment done."
