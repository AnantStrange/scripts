#!/bin/bash

wm_urls=(
    "https://github.com/AnantStrange/dwm.git"
    "https://github.com/AnantStrange/dmenu.git"
    "https://github.com/AnantStrange/st.git"
    "https://github.com/AnantStrange/dwmblocks.git"
    "https://github.com/AnantStrange/tabbed.git"
)

urls=(
    "https://github.com/AnantStrange/dotfiles.git ~/.dotfiles"
    "https://github.com/AnantStrange/scripts.git ~/scripts"
    "https://github.com/AnantStrange/Wallpapers.git ~/Wallpapers/"
    "https://github.com/AnantStrange/password-store.git ~/.local/share/.password-store"

    "https://github.com/agkozak/zsh-z.git ~/.local/share/zsh/zsh-z"
    "https://github.com/zsh-users/zsh-autosuggestions.git ~/.local/share/zsh/zsh-autosuggestions"
    "https://github.com/zdharma-continuum/fast-syntax-highlighting.git ~/.local/share/zsh/fast-syntax-highlight"
    "https://github.com/marlonrichert/zsh-autocomplete.git ~/.local/share/zsh/zsh-autocomplete"
    "https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
)

mkdir -p ~/wm ~/Downloads ~/work ~/.local ~/.local/share ~/local/share/zsh ~/.config

echo -e "\e[34m\n############################### Cloning repositories into wm directory ###############################\e[0m\n"
for url in "${wm_urls[@]}"; do
    echo -e "\e[33mCloning $url into wm dir...\n\e[0m"
    git clone "$url" "wm/$(basename "$url" .git)"
done
echo -e "\e[34m\n############################# Finished cloning repositories into wm directory ############################\e[0m\n"

echo -e "\e[34m\n########################### Cloning repositories ###########################\e[0m\n"
for url in "${urls[@]}"; do
    repo_url="${url%% *}"  # Extracting the repository URL part
    dest="${url#* }"       # Extracting the destination directory part

    # Only prompt for specific repositories
    case "$repo_url" in
        "https://github.com/AnantStrange/password-store.git" | \
        "https://github.com/AnantStrange/Wallpapers.git" | \
        "https://github.com/tmux-plugins/tpm")
            read -p "Do you want to clone $repo_url into $dest? (yes/no): " choice
            if [[ $choice == "yes" ]]; then
                echo -e "\e[33m\nCloning $repo_url into $dest...\n\e[0m"
                git clone "$repo_url" "$dest"
            fi
            ;;
        *)  # For all other repositories, clone without confirmation
            echo -e "\033[33m\nCloning $repo_url into $dest...\n\033[0m"
            git clone "$repo_url" "$dest"
            ;;
    esac
done
echo -e "\e[34m\n############################## Finished cloning repositories ##############################\e[0m\n"


echo -e "\e[31m\n############################## Stowing Dotfiles ##############################\e[0m\n"
if cd "$HOME/.dotfiles"; then
    subdirs=$(find . -mindepth 1 -maxdepth 1 -type d ! -name ".git")
    for dir in $subdirs; do
        # Get the directory name without './'
        dir_name=$(basename "$dir")
        
        read -p "Do you want to stow $dir_name directory? (yes/no)[yes]: " choice
        if [ -z "$choice" ] || [[ $choice == "yes" ]] ; then
            echo -e "\e[33mStowing $dir_name directory...\e[0m"
            stow "$dir_name"
        else
            echo -e "\e[33mSkipping stow for $dir_name directory.\e[0m"
        fi
    done
    echo -e "\e[31m\n############################## Finished Stowing Dotfiles ##############################\e[0m\n"
else
    echo -e "\e[31mError: Unable to navigate to ~/.dotfiles directory.\e[0m"
fi
echo -e "\e[31m\n############################## Finished Stowing Dotfiles ##############################\e[0m\n"


echo -e "\n\e[34m############################## Compiling repositories in wm directory ##############################\e[0m\n"
success=()
failed=()

# Compile each repository in wm dir
for dir in wm/*; do
    echo -e "\e[33mCompiling $dir...\e[0m\n"  # Yellow color for compiling
    cd "$dir"
    sudo make install | tee output.txt
    if [ $? -eq 0 ]; then
        echo -e "\e[32mCompilation successful for $dir\e[0m"  # Green color for successful compilations
        success+=("$dir")
    else
        echo -e "\e[31mCompilation failed for $dir\e[0m"  # Red color for failed compilations
        failed+=("$dir")
    fi
    cd ~
done

# Report successful and failed compilations
echo -e "\n\e[32mSuccessful compilations:\e[0m"  # Green color for successful compilations
for repo in "${success[@]}"; do
    echo -e "\e[32m- $repo\e[0m"  # Green color for successful compilations
done

echo -e "\n\e[31mFailed compilations:\e[0m"  # Red color for failed compilations
for repo in "${failed[@]}"; do
    echo -e "\e[31m- $repo\e[0m"  # Red color for failed compilations
done
echo -e "\n\e[34m############################## Finished compiling repositories ##############################\e[0m\n"

