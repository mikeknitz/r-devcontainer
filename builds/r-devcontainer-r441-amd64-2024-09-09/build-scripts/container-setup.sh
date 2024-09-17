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

# CRAN packages
R -q -e 'install.packages("tidyverse")'
R -q -e 'install.packages("devtools")'
R -q -e 'install.packages("languageserver")'
R -q -e 'devtools::install_github("nx10/httpgd")'
R -q -e 'install.packages("extrafont")'
R -q -e 'install.packages("Cairo")'
R -q -e 'install.packages("BiocManager")'

# Bioconductor packages
R -q -e 'BiocManager::install(version = "3.19", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("SummarizedExperiment", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("AnnotationDbi", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("org.Hs.eg.db", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("org.Mm.eg.db", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("DESeq2", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("clusterProfiler", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("ComplexHeatmap", update = TRUE, ask = FALSE, checkBuilt = TRUE)'

# Import fonts
R -q -e 'extrafont::font_import(prompt = FALSE); extrafont::loadfonts()'

# More CRAN packages
R -q -e 'install.packages("Seurat")'
R -q -e 'devtools::install_github("immunogenomics/presto")'
R -q -e 'install.packages("clustree")'
R -q -e 'install.packages("DT")'
R -q -e 'install.packages("ggh4x")'
R -q -e 'install.packages("ggsci")'
R -q -e 'install.packages("ggpubr")'
R -q -e 'install.packages("ggplotify")'
R -q -e 'install.packages("HGNChelper")'
R -q -e 'install.packages("openxlsx")'
R -q -e 'install.packages("ggnewscale")'
R -q -e 'install.packages("ggbeeswarm")'
R -q -e 'install.packages("dendsort")'
R -q -e 'install.packages("msigdbr")'
R -q -e 'install.packages("hdf5r")'

# Compile Seurat and SeuratObject from source to avoid
  # "built under a different version" warning when loading
R -q -e 'remove.packages("Seurat")'
R -q -e 'install.packages("Seurat", repos = "https://packagemanager.posit.co/cran/2024-09-09", type = "source")'
R -q -e 'remove.packages("SeuratObject")'
R -q -e 'install.packages("SeuratObject", repos = "https://packagemanager.posit.co/cran/2024-09-09", type = "source")'

# Clean up
# https://askubuntu.com/questions/3167/what-is-difference-between-the-options-autoclean-autoremove-and-clean
# https://stackoverflow.com/questions/33902669/good-practice-at-end-of-dockerfile
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo rm -rf /var/lib/apt/lists/*