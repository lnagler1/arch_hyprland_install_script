#!/bin/bash

# Can also be changed to paru if wanted
aurhelper = yay

source global_functions.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

if ! pkg_installed git
then
  echo "Installing git..."a
  sudo pacman -S git
fi

echo "Installing dependency $aurhelper..."
./install_aur.sh $aurhelper 2>&1

install_list = "${1:-install_pkg.lst}"

while read pkg
do
  if pkg_installed ${pkg}
  then
    echo "skipping ${pkg}..."
  elif pkg_available ${pkg}
  then
    echo "queueing ${pkg} from arch repo..."
    pkg_arch=`echo $pkg_arch ${pkg}`
  elif aur_available ${pkg}
  then
    echo "queueing ${pkg} from aur..."
    pkg_aur=`echo $pkg_aur ${pkg}`
  else
    echo "error: unknown package ${pkg}..."
  fi
done > install_list

if [ `echo $pkg_arch | wc -w` -gt 0 ]
then
    echo "installing $pkg_arch from arch repo..."
    sudo pacman -S $pkg_arch
fi

if [ `echo $pkg_aur | wc -w` -gt 0 ]
then
    echo "installing $pkg_aur from aur..."
    $aurhlpr -S $pkg_aur
fi

# Instal oh-my-zsh plugins into plugin folder

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
