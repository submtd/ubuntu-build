#!/bin/bash

# install some dependencies
sudo apt install -y build-essential cmake python-dev python3-dev exuberant-ctags

# install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

mkdir -p ~/.config/nvim
cp ./init.vim ~/.config/nvim/init.vim

vim +PlugInstall +qall
~/.vim/plugged/YouCompleteMe/install.py

