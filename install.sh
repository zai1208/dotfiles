#!/bin/bash

dotfiles_dir=~/dotfiles

# Remove all current dotfiles
echo "[*] Removing current dotfiles"

rm -rf ~/.config
rm -rf ~/.bashrc
rm -rf ~/trueline.sh
rm -rf ~/wallpapers/

# Symlink .config
ln -sf $dotfiles_dir/.config ~/.config

# Symlink wallpapers directory
ln -sf $dotfiles_dir/wallpapers ~/wallpapers

# Symlinking other configs
ln -sf $dotfiles_dir/.bashrc ~/.bashrc
ln -sf $dotfiles_dir/trueline.sh ~/trueline.sh

# installing lf specific things for image preview
mkdir -p ~/.local/bin

sudo chmod +x $dotfiles_dir/bin/lfimg
sudo chmod +x $dotfiles_dir/lf/cleaner
sudo chmod +x $dotfiles_dir/lf/previewer

ln -sf $dotfiles_dir/bin/lfimg ~/.local/bin/lfimg

echo "[*] Dotfiles deployment done."
