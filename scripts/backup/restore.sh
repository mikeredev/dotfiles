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

# Function to create symbolic links. Don't forget the *
create_symlinks() {
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
