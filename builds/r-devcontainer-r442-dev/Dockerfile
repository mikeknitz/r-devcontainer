FROM rocker/rstudio:4.4.2

# Add user "ubuntu" to staff group
RUN usermod -a -G staff ubuntu

# Directory to store scripts and files for the container
# Files are added incrementally in this Dockerfile
  # to preserve build layers for caching, etc.
RUN mkdir /build-scripts

# Install devcontainer features as root
USER root

# common-utils
COPY build-scripts/common-utils /build-scripts/common-utils
WORKDIR /build-scripts/common-utils
RUN INSTALLZSH="true" \
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
COPY build-scripts/git /build-scripts/git
WORKDIR /build-scripts/git
RUN VERSION="latest" \
    PPA="true" \
    /bin/bash install.sh

# tmux
COPY build-scripts/tmux /build-scripts/tmux
WORKDIR /build-scripts/tmux
RUN VERSION="latest" \
  /bin/bash install.sh

# neovim
COPY build-scripts/neovim /build-scripts/neovim
WORKDIR /build-scripts/neovim
RUN VERSION="nightly" \
  /bin/bash install.sh

# neofetch
COPY build-scripts/neofetch /build-scripts/neofetch
WORKDIR /build-scripts/neofetch
RUN /bin/bash install.sh

WORKDIR /

# ssh
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  openssh-client \
  openssh-server
EXPOSE 22

# Make scripts available in container
COPY build-scripts/bin-scripts /build-scripts/bin-scripts
RUN find /build-scripts/bin-scripts/* -type f | xargs -I {} chmod 755 {}
RUN find /build-scripts/bin-scripts/* -type f | xargs -I {} ln -s {} /usr/local/bin/

# python / pip / radian
# python code Adapted from:
  # https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_python.sh
# This section:
  # Installs python3 with pip and venv
  # Installs radian in /opt/venv/bin
  # This bin is then added to staff group and radian symlinked to /usr/local/bin
  # User should probably use their own venv but this is just a way
    # to get a system-wide copy of radian available to all users
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

# # Some code that could be used that edits an R config file, which I think
#   # tells R reticulate where it can use a virtual env and tells RStudio
#   # to by default use a specific venv and corresponding path
# # Best to use this on case-by-case basis if needed
# RUN export VIRTUAL_ENV="/opt/venv" && \
#   export PATH="/opt/venv/bin:${PATH}" && \
#   echo "VIRTUAL_ENV=${VIRTUAL_ENV}" >>"${R_HOME}/etc/Renviron.site" && \
#   echo "PATH=${PATH}" >>"${R_HOME}/etc/Renviron.site"

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

# TinyTeX, Chromium
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh
RUN quarto install chromium

# Git config
RUN git config --global init.defaultBranch main
RUN git config --global pull.ff only
RUN git config --global pager.branch false

# Fonts
# https://askubuntu.com/questions/651441/how-to-install-arial-font-and-other-windows-fonts-in-ubuntu
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
RUN sudo apt-get install -y ttf-mscorefonts-installer
RUN sudo fc-cache -f

# ------------------------------------------------------------------------------
# System dependencies for R packages, etc.
# ------------------------------------------------------------------------------

# Tidyverse, devtools, languageserver compilation
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
  libgit2-dev

# Httpgd
RUN DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --no-install-recommends \
  libcairo2-dev

# Seurat
RUN DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --no-install-recommends \
  libglpk-dev

# HDF5 for h5 single cell objects and loupeR package
RUN DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --no-install-recommends \
  libhdf5-dev

# Magick, for magick, ggkegg, officer packages
RUN DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --no-install-recommends \
  imagemagick \
  libmagick++-dev

# For DirichletMultinomial bioc package for TFBSTools bioc dep of Azimuth
RUN DEBIAN_FRONTEND="noninteractive" sudo apt-get install -y --no-install-recommends \
  libgsl-dev

# Clean up
# https://askubuntu.com/questions/3167/what-is-difference-between-the-options-autoclean-autoremove-and-clean
# https://stackoverflow.com/questions/33902669/good-practice-at-end-of-dockerfile
RUN sudo apt-get autoremove -y && \
  sudo apt-get clean -y && \
  sudo rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------------------------
# R packages
# ------------------------------------------------------------------------------

RUN R -q -e 'install.packages("tidyverse")'
RUN R -q -e 'install.packages("devtools")'
RUN R -q -e 'install.packages("languageserver")'

# httpgd, repo current as of 2024-09-18
RUN R -q -e 'devtools::install_github("nx10/httpgd@b0a5ec38638ca69e3adbc7b24d815757e5f74817")'

RUN R -q -e 'install.packages("extrafont")'
RUN R -q -e 'extrafont::font_import(prompt = FALSE); extrafont::loadfonts()'
RUN R -q -e 'install.packages("Cairo")'

# Recommended for vsn or impute I think
RUN R -q -e 'install.packages("hexbin")'

# Bioconductor
RUN R -q -e 'install.packages("BiocManager")'
RUN R -q -e 'BiocManager::install(version = "3.20",       update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("SummarizedExperiment", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("AnnotationDbi",        update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("org.Hs.eg.db",         update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("org.Mm.eg.db",         update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("DESeq2",               update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("clusterProfiler",      update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("ComplexHeatmap",       update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("limma",                update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("PhosR",                update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("vsn",                  update = TRUE, ask = FALSE, checkBuilt = TRUE)'
RUN R -q -e 'BiocManager::install("impute",               update = TRUE, ask = FALSE, checkBuilt = TRUE)'

# Relies on Bioconductor pacakge impute I think
RUN R -q -e 'install.packages("imputeLCMD")'
RUN R -q -e 'install.packages("Hmisc")'
RUN R -q -e 'install.packages("magick", repos = "https://packagemanager.posit.co/cran/2024-11-04", type = "source")'

RUN R -q -e 'BiocManager::install("ggkegg", update = TRUE, ask = FALSE, checkBuilt = TRUE)'

RUN R -q -e 'install.packages("Seurat")'

# Repo current as of 2024-03-18
RUN R -q -e 'devtools::install_github("immunogenomics/presto@7636b3d0465c468c35853f82f1717d3a64b3c8f6")'

RUN R -q -e 'install.packages("clustree")'
RUN R -q -e 'install.packages("DT")'
RUN R -q -e 'install.packages("ggh4x")'
RUN R -q -e 'install.packages("ggsci")'
RUN R -q -e 'install.packages("ggpubr")'
RUN R -q -e 'install.packages("ggplotify")'
RUN R -q -e 'install.packages("HGNChelper")'
RUN R -q -e 'install.packages("openxlsx")'
RUN R -q -e 'install.packages("ggnewscale")'
RUN R -q -e 'install.packages("ggbeeswarm")'
RUN R -q -e 'install.packages("dendsort")'
RUN R -q -e 'install.packages("msigdbr")'
RUN R -q -e 'install.packages("hdf5r")'

# Repo current as of 2024-10-29 I think
RUN R -q -e 'devtools::install_github("10XGenomics/loupeR@a169417e7a0d59ae7ebba042a4f100de8efb8101")'

# Force source install of Seurat (may have been built with binary)
# and avoid "built under a different version" warnings
RUN R -q -e 'remove.packages("Seurat")'
RUN R -q -e 'install.packages("Seurat", repos = "https://packagemanager.posit.co/cran/2024-11-04", type = "source")'
RUN R -q -e 'remove.packages("SeuratObject")'
RUN R -q -e 'install.packages("SeuratObject", repos = "https://packagemanager.posit.co/cran/2024-11-04", type = "source")'

RUN R -q -e 'install.packages("officer")'
RUN R -q -e 'install.packages("rsvg")'

RUN R -q -e 'install.packages("harmony")'

CMD ["/usr/bin/zsh"]
