FROM rocker/r-ver:4.4.1

# Add a non-root user "ubuntu"
RUN useradd -s /bin/bash -m ubuntu \
  && usermod -a -G staff ubuntu

# Directory to store scripts and files for the container
# Files are added incrementally in this Dockerfile
  # to preserve build layers for caching, etc.
RUN /bin/bash -c "mkdir /build-scripts"

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

# pandoc
COPY build-scripts/pandoc /build-scripts/pandoc
WORKDIR /build-scripts/pandoc
RUN VERSION="latest" \
  /bin/bash install.sh

# quarto
COPY build-scripts/quarto-cli /build-scripts/quarto-cli
WORKDIR /build-scripts/quarto-cli
RUN VERSION="latest" \
  INSTALLTINYTEX="false" \
  INSTALLCHROMIUM="false" \
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

# rstudio-server
COPY build-scripts/rstudio-server /build-scripts/rstudio-server
WORKDIR /build-scripts/rstudio-server
RUN VERSION="daily" \
    ALLOWREINSTALL="true" \
    SINGLEUSER="true" \
    USERNAME="ubuntu" \
    /bin/bash install.sh

# ssh
RUN /bin/bash -c "apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get install -y \
  openssh-client \
  openssh-server"
EXPOSE 22

# Make scripts available in container
COPY build-scripts/bin-scripts /build-scripts/bin-scripts
RUN /bin/bash -c "find /build-scripts/bin-scripts/* -type f | xargs -I {} chmod 755 {}"
RUN /bin/bash -c "find /build-scripts/bin-scripts/* -type f | xargs -I {} ln -s {} /usr/local/bin/"

# dotfiles for non-root user
COPY build-scripts/dotfiles /build-scripts/dotfiles

# Change to non-root user
USER ubuntu
WORKDIR /home/ubuntu

# dotfiles
COPY build-scripts/dotfiles /build-scripts/dotfiles
RUN /bin/bash -c "cp /build-scripts/dotfiles/.lintr ~/.lintr"
RUN /bin/bash -c "cp /build-scripts/dotfiles/.Rprofile ~/.Rprofile"
RUN /bin/bash -c "cp /build-scripts/dotfiles/.zshrc ~/.zshrc"
RUN /bin/bash -c "mkdir -p ~/.config/rstudio"
RUN /bin/bash -c "cp /build-scripts/dotfiles/rstudio-prefs.json ~/.config/rstudio/rstudio-prefs.json"
RUN /bin/bash -c "mv ~/.oh-my-zsh ~/.zsh"
RUN /bin/bash -c "cp /build-scripts/dotfiles/mk.zsh-theme ~/.zsh/custom/themes/mk.zsh-theme"

# TinyTeX, Chromium
RUN /bin/bash -c 'wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh'
RUN /bin/bash -c "quarto install chromium"

# R dependencies, radian, and R packages
COPY build-scripts/system-software.sh /build-scripts/system-software.sh
COPY build-scripts/r-packages.sh /build-scripts/r-packages.sh
RUN /bin/bash -c "sudo touch /build-scripts/system-software-log.txt"
RUN /bin/bash -c "sudo touch /build-scripts/r-packages-log.txt"
RUN /bin/bash -c "sudo chmod 777 /build-scripts/system-software-log.txt"
RUN /bin/bash -c "sudo chmod 777 /build-scripts/r-packages-log.txt"
RUN /bin/bash /build-scripts/system-software.sh 2>&1 | tee /build-scripts/system-software-log.txt
RUN /bin/bash /build-scripts/r-packages.sh 2>&1 | tee /build-scripts/r-packages-log.txt

CMD ["/usr/bin/zsh"]
