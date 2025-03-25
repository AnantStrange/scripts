#!/bin/bash

# Define URLs for the repositories
urls=(
    "https://github.com/AnantStrange/dwm.git"
    "https://github.com/AnantStrange/dwmblocks.git"
    "https://github.com/AnantStrange/dmenu.git"
    "https://github.com/AnantStrange/tabbed.git"
    "https://github.com/AnantStrange/st.git"

    "https://github.com/AnantStrange/password-store.git"

    "https://github.com/AnantStrange/dotfiles.git"
    "https://github.com/AnantStrange/scripts.git"

    "https://github.com/AnantStrange/Wallpapers.git"
)

# Define categories
wm_repos=("dwm" "dwmblocks" "dmenu" "tabbed" "st")
general_repos=("dotfiles" "scripts")
misc_repos=("password-store","Wallpapers")

# Function to prompt user for confirmation
prompt_user() {
    local category="$1"
    read -p "Do you want to clone $category repositories? (y/n): " choice
    case "$choice" in
        y|Y) return 0 ;;
        n|N) return 1 ;;
        *) echo "Invalid choice. Please enter y or n." ; prompt_user "$category" ;;
    esac
}

# Function to clone repositories
clone_repos() {
    local category="$1"
    local repos=("${!2}")
    local target_dir="$3"

    echo "Cloning $category repositories into $target_dir..."
    mkdir -p "$target_dir"
    for repo in "${repos[@]}"; do
        for url in "${urls[@]}"; do
            if [[ "$url" == *"$repo"* ]]; then
                echo "Cloning $repo..."
                git clone "$url" "$target_dir/$repo"
                break
            fi
        done
    done
}

# Function to install WM-related repositories
install_wm_repos() {
    local wm_dir="$HOME/wm"
    for repo in "${wm_repos[@]}"; do
        echo "Installing $repo..."
        cd "$wm_dir/$repo" || { echo "Failed to cd into $wm_dir/$repo"; exit 1; }
        sudo make clean install
    done
}

# Function to handle dotfiles submodule
handle_dotfiles_submodule() {
    local dotfiles_dir="$HOME/.dotfiles"
    echo "Initializing and updating submodules for dotfiles..."
    cd "$dotfiles_dir" || { echo "Failed to cd into $dotfiles_dir"; exit 1; }
    git submodule update --init --recursive
}

# Main script logic

# Clone WM-related repositories
if prompt_user "Window Manager"; then
    clone_repos "Window Manager" wm_repos[@] "$HOME/wm"
    install_wm_repos
fi

# Clone General repositories
if prompt_user "General"; then
    clone_repos "General" general_repos[@] "$HOME/.dotfiles"
    handle_dotfiles_submodule
    clone_repos "General" general_repos[@] "$HOME/scripts"
fi

# Clone Misc repositories
if prompt_user "Miscellaneous"; then
    clone_repos "Miscellaneous" misc_repos[@] "$HOME/.local/share/.password-store"
fi

echo "Setup complete!"
