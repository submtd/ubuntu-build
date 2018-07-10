#!/bin/bash

# set up ssh key
cat /dev/zero | ssh-keygen -q -N ""

# google chrome ppa
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

sudo apt update
sudo apt install -y git curl wget htop neovim tree ranger gnome-tweak-tool google-chrome-stable

