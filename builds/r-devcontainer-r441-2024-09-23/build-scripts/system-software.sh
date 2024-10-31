#!/bin/bash

set -e

# System dependencies
sudo apt-get update

# Python / pip / radian
sudo apt-get install -y python3-pip
sudo pip3 install -U radian

# Git
git config --global init.defaultBranch main
git config --global pull.ff only
git config --global pager.branch false

# tidyverse, devtools, languageserver compilation
sudo apt-get install -y \
  libcurl4-openssl-dev  \
  libssl-dev            \
  libxml2-dev           \
  libfontconfig1-dev    \
  libharfbuzz-dev       \
  libfribidi-dev        \
  libfreetype6-dev      \
  libpng-dev            \
  libtiff5-dev          \
  libjpeg-dev           \
  libgit2-dev

# Fonts
# https://askubuntu.com/questions/651441/how-to-install-arial-font-and-other-windows-fonts-in-ubuntu
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
sudo apt-get install -y ttf-mscorefonts-installer
sudo fc-cache -f

# httpgd compilation
sudo apt-get install -y libcairo2-dev

# Seurat compilation
sudo apt-get install -y libglpk-dev

# HDF5 for h5 single cell objects and loupeR package
sudo apt-get install -y libhdf5-dev

# Magick, helps for R magick and ggkegg packages
sudo apt-get install -y imagemagick     
sudo apt-get install -y libmagick++-dev 

# Clean up
# https://askubuntu.com/questions/3167/what-is-difference-between-the-options-autoclean-autoremove-and-clean
# https://stackoverflow.com/questions/33902669/good-practice-at-end-of-dockerfile
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*
