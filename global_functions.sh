#!/bin/bash

set -e

CloneDir=`dirname $(dirname $(realpath $0))`

pkg_installed()
{
  local PkgInput = $1
  if pacman -Qi $PkgInput &> /dev/null
  then
    # Pkg ist already installed
    return 0;
  else
    # Pkg ist not installed
    return 1;
  fi
}

pkg_available()
{
    local PkgInput=$1

    if pacman -Si $PkgInput &> /dev/null
    then
        #echo "${PkgIn} available in arch repo..."
        return 0
    else
        #echo "${PkgIn} not available in arch repo..."
        return 1
    fi
}

aur_available()
{
    local PkgInput=$1
    chk_aurh

    if $aurhelper -Si $PkgInput &> /dev/null
    then
        #echo "${PkgIn} available in aur repo..."
        return 0
    else
        #echo "aur helper is not installed..."
        return 1
    fi
}
