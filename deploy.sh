#!/bin/bash

echo "Deploying your configurations with GNU Stow..."

if ! command -v stow &> /dev/null; then
    echo "[!] Stow is not installed. Install it first."
    exit 1
fi

mkdir -p ~/.config

cd ~/dotfiles
stow git bash nvim hyprland waybar foot fuzzel mako

echo "[OK] Your dotfiles are in place! Welcome home!"
