#!/bin/bash

# Function to update user-dirs.dirs
update_user_dirs() {
    user_dirs_file="$HOME/.config/user-dirs.dirs"

    cat <<EOL > "$user_dirs_file"
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_TEMPLATES_DIR="$HOME/templates"
XDG_PUBLICSHARE_DIR="$HOME/public"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_VIDEOS_DIR="$HOME/videos"
EOL

    xdg-user-dirs-update
    echo "user-dirs.dirs updated!"
}

# Function to create symbolic links and ensure directories exist
create_symlinks() {
    mkdir -p ~/.config/alacritty
    mkdir -p ~/.config/dunst
    mkdir -p ~/.config/gtk-3.0
    mkdir -p ~/.config/i3
    mkdir -p ~/.config/i3blocks
    mkdir -p ~/.config/mplite
    mkdir -p ~/.config/picom
    mkdir -p ~/.config/rofi
    mkdir -p ~/.config/scripts
    mkdir -p ~/.config/vim
    mkdir -p ~/.config/VSCodium/User

    ln -sf ~/documents/github/dotfiles/alacritty/* ~/.config/alacritty/
    ln -sf ~/documents/github/dotfiles/bash/bashrc ~/.bashrc
    ln -sf ~/documents/github/dotfiles/dunst/* ~/.config/dunst/
    ln -sf ~/documents/github/dotfiles/gtk-3.0/* ~/.config/gtk-3.0/
    ln -sf ~/documents/github/dotfiles/i3/* ~/.config/i3/
    ln -sf ~/documents/github/dotfiles/i3blocks/* ~/.config/i3blocks/
    ln -sf /home/mishi/documents/github/dotfiles/mplite/* ~/.config/mplite/
    ln -sf ~/documents/github/dotfiles/picom/* ~/.config/picom/
    ln -sf ~/documents/github/dotfiles/redshift/redshift.conf ~/.config/
    ln -sf ~/documents/github/dotfiles/rofi/* ~/.config/rofi/
    ln -sf ~/documents/github/dotfiles/scripts/* ~/.config/scripts/
    ln -sf ~/documents/github/dotfiles/vim/* ~/.config/vim/
    ln -sf ~/documents/github/dotfiles/vscodium/settings.json ~/.config/VSCodium/User/settings.json

    echo "Files restored!"
}

read -p "Do you want to update user-dirs.dirs? (y/n): " response

if [ "$response" == "y" ]; then
    update_user_dirs
else
    echo "User-dirs.dirs operation canceled."
fi

read -p "Do you want to restore these files? (y/n): " response

if [ "$response" == "y" ]; then
    create_symlinks
else
    echo "Symlinks operation canceled."
fi
