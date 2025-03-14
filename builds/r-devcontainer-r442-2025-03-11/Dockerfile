FROM rocker/rstudio:4.4.2

# Create a non-root user "ubuntu" and add to staff group
RUN useradd -s /bin/bash -m ubuntu \
  && usermod -a -G staff ubuntu

# Directory to store scripts and files for the container
# Files are added incrementally in this Dockerfile
  # to preserve build layers for caching, etc.
RUN mkdir /build-scripts
COPY build-scripts/pulled-scripts /build-scripts/pulled-scripts

# Install devcontainer features as root
USER root

# ==============================================================================
# Install pulled devcontainer features
# ==============================================================================

# common-utils
  # which includes a zsh install
RUN cd /build-scripts/pulled-scripts/common-utils && \
  INSTALLZSH="true" \
  CONFIGUREZSHASDEFAULTSHELL="true" \
  INSTALLOHMYZSH="true" \
  INSTALLOHMYZSHCONFIG="true" \
  UPGRADEPACKAGES="true" \
  USERNAME="ubuntu" \
  USERUID="automatic" \
  USERGID="automatic" \
  NONFREEPACKAGES="true" \
  /bin/bash main.sh

# git
RUN cd build-scripts/pulled-scripts/git && \
  VERSION="latest" \
  PPA="true" \
  /bin/bash install.sh

# tmux
RUN cd /build-scripts/pulled-scripts/tmux && \
  VERSION="latest" \
  /bin/bash install.sh

# neovim
RUN cd /build-scripts/pulled-scripts/neovim && \
  VERSION="nightly" \
  /bin/bash install.sh

# neofetch
RUN cd /build-scripts/pulled-scripts/neofetch && \
  /bin/bash install.sh

# ==============================================================================
# Other misc setup
# ==============================================================================

WORKDIR /

# ssh functionality
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  openssh-client \
  openssh-server

# Copy in various scripts to /build-scripts/bin-scripts/
# Make symlinks in /usr/local/bin to be availabe in container
COPY build-scripts/bin-scripts /build-scripts/bin-scripts
RUN find /build-scripts/bin-scripts/* -type f | xargs -I {} chmod 755 {}
RUN find /build-scripts/bin-scripts/* -type f | xargs -I {} ln -s {} /usr/local/bin/

# ==============================================================================
# Python
# ==============================================================================

# python / pip / radian
# python code Adapted from:
  # https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_python.sh
# This section:
  # Installs python3, including installs of pip and venv
  # Create python venv at /opt/venv
  # Installs radian into /opt/venv/bin
  # This venv folder is chown to the staff group
  # radian is symlinked into /usr/local/bin
  # Users should generally use their own venv, but this is so a system-wide
    # copy of radian is immediately available in the path of all users

# If python not available, may need to add universe repo
# RUN DEBIAN_FRONTEND="noninteractive" add-apt-repository universe && apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
  libpython3-dev \
  python3-dev \
  python3-pip \
  python3-venv
RUN python3 -m venv /opt/venv && \
  /opt/venv/bin/python3 -m pip --no-cache-dir install --upgrade pip && \
  /opt/venv/bin/python3 -m pip install -U radian
RUN chown -R root:staff "/opt/venv"
RUN chmod -R g+ws "/opt/venv"
RUN ln -s /opt/venv/bin/radian /usr/local/bin

# # Some code that could be added that edits an R config file, which I think
#   # tells R reticulate where it can use a virtual env and tells RStudio
#   # to by default use a specific venv and corresponding path
# # Best to use this on case-by-case basis if needed
# # I prefer to exclude this and manually activate a venv for RStudio if needed
# RUN export VIRTUAL_ENV="/opt/venv" && \
#   export PATH="/opt/venv/bin:${PATH}" && \
#   echo "VIRTUAL_ENV=${VIRTUAL_ENV}" >>"${R_HOME}/etc/Renviron.site" && \
#   echo "PATH=${PATH}" >>"${R_HOME}/etc/Renviron.site"

# ==============================================================================
# Non-root user "ubuntu": dotfiles and user settings
# ==============================================================================

# Change to non-root user
USER ubuntu
WORKDIR /home/ubuntu

# dotfiles for non-root user
COPY build-scripts/dotfiles /build-scripts/dotfiles
RUN cp /build-scripts/dotfiles/.lintr ~/.lintr
RUN cp /build-scripts/dotfiles/.Rprofile ~/.Rprofile
RUN cp /build-scripts/dotfiles/.zshrc ~/.zshrc
RUN mkdir -p ~/.config/rstudio
RUN cp /build-scripts/dotfiles/rstudio-prefs.json ~/.config/rstudio/rstudio-prefs.json
RUN mv ~/.oh-my-zsh ~/.zsh
RUN cp /build-scripts/dotfiles/mk.zsh-theme ~/.zsh/custom/themes/mk.zsh-theme

# Git config settings I like
RUN git config --global init.defaultBranch main
RUN git config --global pull.ff only
RUN git config --global pager.branch false

# ==============================================================================
# Other software
# ==============================================================================

# TinyTeX, Chromium
# Quarto already previously installed in this image
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
RUN quarto install chromium

# Fonts
# https://askubuntu.com/questions/651441/how-to-install-arial-font-and-other-windows-fonts-in-ubuntu
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
RUN sudo apt-get install -y ttf-mscorefonts-installer
RUN sudo fc-cache -f

# ==============================================================================
# System dependencies for R packages, etc.
# ==============================================================================

# Tidyverse, devtools, languageserver compilation
  # libcurl4-openssl-dev
  # libssl-dev
  # libxml2-dev
  # libfontconfig1-dev
  # libharfbuzz-dev
  # libfribidi-dev
  # libfreetype6-dev
  # libpng-dev
  # libtiff5-dev
  # libjpeg-dev
  # libgit2-dev
# libcairo2-dev httpgd
# libglpk-dev Seurat
# libhdf5-dev HDF5 for scRNA objects and loupeR package
# imagemagick, libmagick++-dev, for R magick, ggkegg, officer packages
# libgsl-dev For DirichletMultinomial bioc package for TFBSTools bioc dep of Azimuth

RUN DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --no-install-recommends \
  libcurl4-openssl-dev \
  libssl-dev           \
  libxml2-dev          \
  libfontconfig1-dev   \
  libharfbuzz-dev      \
  libfribidi-dev       \
  libfreetype6-dev     \
  libpng-dev           \
  libtiff5-dev         \
  libjpeg-dev          \
  libgit2-dev          \
  libcairo2-dev        \
  libglpk-dev          \
  libhdf5-dev          \
  imagemagick          \
  libmagick++-dev      \
  libgsl-dev

# Clean up
# https://askubuntu.com/questions/3167/what-is-difference-between-the-options-autoclean-autoremove-and-clean
# https://stackoverflow.com/questions/33902669/good-practice-at-end-of-dockerfile
RUN sudo apt-get autoremove -y && \
  sudo apt-get clean -y && \
  sudo rm -rf /var/lib/apt/lists/*

# ==============================================================================
# R packages
# ==============================================================================

# These are installed by user "ubuntu" above
# See build-scripts/dotfiles/.Rprofile (which becomes ~/.Rprofile in container)
  # This .Rprofile sets specific Bioconductor and CRAN mirrors
  # By default the R install.packages() and BiocManager::install() functions
    # will use these date-specific mirrors, only exception are some of the
    # commands below that install from github and are set to install based
    # on a specific commit SHA

RUN R -q -e 'install.packages(c("tidyverse", "devtools", "languageserver", "extrafont"))'
# Configure fonts that were installed above for ttf-mscorefonts-installer
RUN R -q -e 'extrafont::font_import(prompt = FALSE); extrafont::loadfonts()'

# httpgd from github, latest commit as of 2025-03-13
RUN R -q -e 'devtools::install_github("nx10/httpgd@7181a6fb9c863b710ebcf718f0585070aab5c194")'

# ManuelHentschel/vscDebugger from github, latest commit as of 2025-03-13
RUN R -q -e 'devtools::install_github("ManuelHentschel/vscDebugger@83e91154629de8cb81d043dea24fd78f77c6108c")'

# hexbin: recommend for vsn or impute packages I think
RUN R -q -e 'install.packages(c("Cairo", "hexbin"))'

RUN R -q -e 'install.packages("BiocManager")'
RUN R -q -e 'BiocManager::install(version = "3.20", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install(c("SummarizedExperiment", "AnnotationDbi", "org.Hs.eg.db", "org.Mm.eg.db", "DESeq2", "clusterProfiler", "ComplexHeatmap", "limma", "PhosR", "vsn", "impute"), update = TRUE, ask = FALSE, checkBuilt = TRUE)'

# Relies on Bioconductor pacakge impute maybe
RUN R -q -e 'install.packages("imputeLCMD")'

RUN R -q -e 'install.packages("Hmisc")'

# Source install seems to work better for magick
RUN R -q -e 'install.packages("magick", repos = "https://packagemanager.posit.co/cran/2025-03-11", type = "source")'

RUN R -q -e 'BiocManager::install("ggkegg", update = TRUE, ask = FALSE, checkBuilt = TRUE)'

RUN R -q -e 'install.packages("Seurat")'
# Force source install of Seurat (may have been built with binary above already)
# and avoid "built under a different version" warnings when loading package
RUN R -q -e 'remove.packages("Seurat")'
RUN R -q -e 'install.packages("Seurat", repos = "https://packagemanager.posit.co/cran/2025-03-11", type = "source")'
RUN R -q -e 'remove.packages("SeuratObject")'
RUN R -q -e 'install.packages("SeuratObject", repos = "https://packagemanager.posit.co/cran/2025-03-11", type = "source")'

# SeuratData from github, latest commit as of 2025-03-13
RUN R -q -e 'devtools::install_github("satijalab/seurat-data@3e51f44303069b64f5dc4d68e6a3d4a343f55c39")'

# immunogenics/presto from github, latest commit as of 2025-03-13
RUN R -q -e 'devtools::install_github("immunogenomics/presto@7636b3d0465c468c35853f82f1717d3a64b3c8f6")'

RUN R -q -e 'install.packages(c("clustree", "DT", "ggh4x", "ggsci", "ggpubr", "ggplotify", "HGNChelper", "openxlsx", "ggnewscale", "ggbeeswarm", "dendsort", "msigdbr", "hdf5r"))'

# 10XGenomics/loupeR from github, latest commit as of 2025-03-13
RUN R -q -e 'devtools::install_github("10XGenomics/loupeR@fb9c6d1cddeeb6760d77c0c836a114f0e15c271a")'

RUN R -q -e 'install.packages(c("officer", "rsvg", "harmony", "sctransform"))'

RUN R -q -e 'BiocManager::install(c("glmGamPoi", "biomaRt", "SingleR", "celldex", "scRNAseq", "edgeR", "scuttle", "scran", "GSVA", "KEGGgraph", "flowCore"), update = TRUE, ask = FALSE, checkBuilt = TRUE)'

# ParkerICI/premessa from github, latest commit as of 2025-03-13
RUN R -q -e 'devtools::install_github("ParkerICI/premessa@68b42bb984637d0f3ad6a0ecc83e9278994afc85")'

RUN R -q -e 'install.packages("webshot", repos = "https://packagemanager.posit.co/cran/2025-03-11", type = "source")'

RUN R -q -e 'install.packages(c("optparse", "factoextra", "ggdist", "writexl", "survminer"))'

# ==============================================================================
# ==============================================================================

# Command run to start container
CMD ["/usr/bin/zsh"]
