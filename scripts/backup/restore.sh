#!/bin/bash

read -p "do you want to restore dotfiles? (y/n): " response

if [ "$response" == "y" ]; then
    # Don't forget the *
    ln -s ~/documents/github/dotfiles/alacritty/* ~/.config/alacritty/
    ln -s ~/documents/github/dotfiles/bash/.bashrc ~/.bashrc
    ln -s ~/documents/github/dotfiles/dunst/* ~/.config/dunst/
    ln -s ~/documents/github/dotfiles/gtk-3.0/* ~/.config/gtk-3.0/
    ln -s ~/documents/github/dotfiles/i3/* ~/.config/i3/
    ln -s ~/documents/github/dotfiles/i3blocks/* ~/.config/i3blocks/
    ln -s ~/documents/github/dotfiles/picom/* ~/.config/picom/
    ln -s ~/documents/github/dotfiles/redshift/redshift.conf ~/.config/
    ln -s ~/documents/github/dotfiles/rofi/* ~/.config/rofi/
    ln -s ~/documents/github/dotfiles/scripts/* ~/.config/scripts/
    ln -s ~/documents/github/dotfiles/vim/* ~/.config/vim/
    ln -s ~/documents/github/dotfiles/vscodium/settings.json ~/.config/VSCodium/User/settings.json
    echo "Files restored!"
else
    echo "Operation canceled."
fi
