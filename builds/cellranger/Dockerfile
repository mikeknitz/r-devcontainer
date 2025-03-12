FROM ubuntu:22.04

# Add a non-root user "ubuntu"
RUN useradd -s /bin/bash -m ubuntu \
  && usermod -a -G staff ubuntu

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

# Some setup code adapted from here for this miscellaneous system deps
# https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_R_source.sh

## Locale
RUN /usr/sbin/locale-gen --lang "en_US.UTF-8"
RUN /usr/sbin/update-locale --reset LANG="en_US.UTF-8"

# Packages
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
  locales \
  build-essential \
  software-properties-common \
  bash-completion \
  ca-certificates \
  file \
  fonts-texgyre \
  g++ \
  gfortran \
  gsfonts \
  libblas-dev \
  libbz2-* \
  libcurl4 \
  "libicu[0-9][0-9]" \
  liblapack-dev \
  libpcre2* \
  libjpeg-turbo* \
  libpangocairo-* \
  libpng16* \
  libreadline8 \
  libtiff* \
  liblzma* \
  libxt6 \
  make \
  tzdata \
  unzip \
  zip \
  zlib1g

# ssh
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  openssh-client \
  openssh-server
EXPOSE 22

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

# cellranger
COPY build-scripts/cellranger-files /build-scripts/cellranger-files
WORKDIR /build-scripts/cellranger-files
RUN tar -xzf cellranger-9.0.1.tar.gz
RUN rm cellranger-9.0.1.tar.gz
RUN chown -R root:staff "cellranger-9.0.1/bin"
RUN chmod -R g+ws "cellranger-9.0.1/bin"
RUN ln -s /build-scripts/cellranger-files/cellranger-9.0.1/bin/cellranger /usr/local/bin

WORKDIR /

# # Make scripts available in container
# COPY build-scripts/bin-scripts /build-scripts/bin-scripts
# RUN find /build-scripts/bin-scripts/* -type f | xargs -I {} chmod 755 {}
# RUN find /build-scripts/bin-scripts/* -type f | xargs -I {} ln -s {} /usr/local/bin/
 
# python / pip / radian
# python code Adapted from:
  # https://github.com/rocker-org/rocker-versioned2/blob/master/scripts/install_python.sh
# This section:
  # Installs python3 with pip and venv
  # Installs radian in /opt/venv/bin
  # This bin is then added to staff group and radian symlinked to /usr/local/bin
  # User should probably use their own venv but this is just a way
    # to get a system-wide copy of radian available to all users

# # 2025-03-11: Add universe repo, not in main?
RUN DEBIAN_FRONTEND="noninteractive" add-apt-repository universe && apt-get update

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

# Git config
RUN git config --global init.defaultBranch main
RUN git config --global pull.ff only
RUN git config --global pager.branch false

# Fonts
# https://askubuntu.com/questions/651441/how-to-install-arial-font-and-other-windows-fonts-in-ubuntu
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | sudo debconf-set-selections
RUN sudo apt-get install -y ttf-mscorefonts-installer
RUN sudo fc-cache -f

# Clean up
# https://askubuntu.com/questions/3167/what-is-difference-between-the-options-autoclean-autoremove-and-clean
# https://stackoverflow.com/questions/33902669/good-practice-at-end-of-dockerfile
RUN sudo apt-get autoremove -y && \
  sudo apt-get clean -y && \
  sudo rm -rf /var/lib/apt/lists/*

# Command
CMD ["/usr/bin/zsh"]