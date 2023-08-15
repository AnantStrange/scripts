#for i in $(cat ./dependency)
#do
#        echo "$i"
#done
#

mkdir ~/work 
cd work

mkdir ~/wm
mkdir -p ~/.local/share

git clone https://github.com/AnantStrange/dwm.git ~/wm
git clone https://github.com/AnantStrange/dwmblocks.git ~/wm
git clone https://github.com/AnantStrange/dmenu.git ~/wm
git clone https://github.com/AnantStrange/tabbed.git ~/wm
git clone https://github.com/AnantStrange/st.git ~/wm

git clone https://github.com/AnantStrange/password-store.git ~/.local/share
git clone https://github.com/AnantStrange/dotfiles.git 
git clone https://github.com/AnantStrange/scripts.git ~


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


cd ~/work/dotfiles
mv .alias .xinitrc .zprofile .zsh_history .zshrc -t ~
mkdir -p ~/.config/picom/
mkdir -p ~/.config/sxhkd
mv picom.conf ~/.config/picom
mv sxhkd ~/.config/sxhkd

cd ~/work




