#!/bin/sh

urls=("https://github.com/AnantStrange/dwm.git" "https://github.com/AnantStrange/dwmblocks.git" "https://github.com/AnantStrange/dmenu.git" "https://github.com/AnantStrange/tabbed.git" "https://github.com/AnantStrange/st.git" "https://github.com/AnantStrange/password-store.git" "https://github.com/AnantStrange/dotfiles.git" "https://github.com/AnantStrange/scripts.git")

if ! nc -zw1 google.com 443;then
    printf "We do not have Internet conectivity!\nCHeck your internet Connection"
    exit
fi

mkdir ~/wm
mkdir -p ~/.local/share

cd ~/wm
for url in "${urls[@]}";do
    while ! (git clone "$url"); 
    do 
        printf "\nGit Clone Failed.\nRetry? (y/n) >"
        while read -r choice;do
            case "$choice" in
                "n")
                    printf "Do you want to exit or skip this repo? (exit/skip) >"
                    while read -r choice;do
                        case "$choice" in 
                            "exit") echo "exit called"; exit;;
                            "skip") printf "\n" ;break;;
                            *)      printf "Incorrect value option!\nPlease enter the correct value: " ;;
                        esac
                    done
                    ;;
                "y") printf "\n";break;;
                *) printf "Incorrect value option!\nPlease enter the correct value: " ;;
            esac
            break
        done
        [ "$choice" = "skip" ] && break
    done
done


[ -d "$HOME/wm/password-store" ] && mv ~/wm/password-store ~/.local/share/.password-store
[ -d "$HOME/wm/scripts" ] && mv ~/wm/scripts ~/scripts
[ -d "$HOME/wm/dotfiles" ] && mv ~/wm/dotfiles ~/.dotfiles

#
# for url in "${urls[@]}";do
#     while ! (git clone "$url"); 
#     do 
#         printf "\nGit Clone Failed.\nRetry? (y/n) >"
#         while read -r choice;do
#             case "$choice" in
#                 "n")
#                     printf "Do you want to exit or skip this repo? (exit/skip) >"
#                     while read -r choice;do
#                         case "$choice" in 
#                             "exit") echo "exit called"; exit;;
#                             "skip") printf "\n" ;break;;
#                             *)      printf "Incorrect value option!\nPlease enter the correct value: " ;;
#                         esac
#                     done
#                     ;;
#                 "y") printf "\n";break;;
#                 *) printf "Incorrect value option!\nPlease enter the correct value: " ;;
#             esac
#             break
#         done
#         [ "$choice" = "skip" ] && break
#     done
# done

# git clone https://github.com/AnantStrange/dwm.git ~/wm
# git clone https://github.com/AnantStrange/dwmblocks.git ~/wm
# git clone https://github.com/AnantStrange/dmenu.git ~/wm
# git clone https://github.com/AnantStrange/tabbed.git ~/wm
# git clone https://github.com/AnantStrange/st.git ~/wm
#
# git clone https://github.com/AnantStrange/password-store.git ~/.local/share
# git clone https://github.com/AnantStrange/dotfiles.git ~ && mv dotfiles .dotfiles
# git clone https://github.com/AnantStrange/scripts.git ~
#

cd ~/wm/dwm  
sudo make clean install

cd ~/wm/dwmblocks
sudo make clean install

cd ~/wm/dmenu
sudo make clean install

cd ~/wm/tabbed 
sudo make clean install

cd ~/wm/st
sudo make clean install

cd ~/.dotfiles
git submodule update --init --recursive
stow *






