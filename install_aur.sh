#!/bin/bash

source global_functions.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

if pkg_installed $1
then
  echo "aurhelper is already installed"
  exit 0
fi

if [ -d ~/Clone ]
then
  echo "Clone already exists"
  rm -rf ~/clone/$1
else
  mkdir ~/Clone
  echo -e "[Desktop Entry]\nIcon=default-folder-git" > ~/Clone/.directory
  echo "Cloned directory created"
fi

if pkg_installed git 
then
  git clone https://aur.archlinux.org/$aurhlpr.git ~/Clone/$aurhlpr
else
  echo "git is not installed"
  exit 1
fi

cd ~/Clone/$1
makepkg --noconfirm -si

if [ $? -eq 0]
then
  echo "$1 aur helper installed"
  exit 0
else
  echo "$1 installation failed"
  exit 1
fi

