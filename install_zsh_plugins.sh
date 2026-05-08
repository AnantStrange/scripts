#! /usr/bin/env zsh

if [[ -f /etc/arch-release ]]; then
    echo "Detected Arch Linux. Installing plugins via package manager."
    
    sudo pacman -S --noconfirm zsh-autosuggestions zsh-autocomplete
    
    if command -v paru &>/dev/null; then
        paru -S --noconfirm zsh-fast-syntax-highlighting-git zsh-z-git
    elif command -v yay &>/dev/null; then
        yay -S --noconfirm zsh-fast-syntax-highlighting-git zsh-z-git
    else
        echo "No AUR helper found! Install paru or yay manually and install zsh-fast-syntax-highlighting-git."
    fi
else
    echo "Non-Arch system detected. Cloning plugins manually."
    ZSH_PLUGIN_DIR="$HOME/.local/share/zsh"
    [ -z "$ZSH_PLUGIN_DIR" ] && mkdir -p "$ZSH_PLUGIN_DIR"

    declare -A ZSH_PLUGINS=(
        ["zsh-z"]="https://github.com/agkozak/zsh-z.git"
        ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
        ["fast-syntax-highlight"]="https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        ["zsh-autocomplete"]="https://github.com/marlonrichert/zsh-autocomplete.git"
    )
    for plugin in "${!ZSH_PLUGINS[@]}"; do
        if [[ ! -d "$ZSH_PLUGIN_DIR/$plugin" ]]; then
            echo "Cloning $plugin..."
            git clone --depth=1 "${ZSH_PLUGINS[$plugin]}" "$ZSH_PLUGIN_DIR/$plugin"
        fi
    done
fi


# Install additional utilities
for pkg in fzf direnv; do
    if ! command -v "$pkg" &>/dev/null; then
        if [[ -f /etc/arch-release ]]; then
            echo "$pkg not found! Installing..."
            sudo pacman -S --noconfirm "$pkg"
        elif command -v apt &>/dev/null; then
            echo "$pkg not found! Installing..."
            sudo apt install -y "$pkg"
        else
            echo "$pkg not found! Please install it manually."
        fi
    fi
done

