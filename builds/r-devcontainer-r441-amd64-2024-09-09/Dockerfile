FROM rocker/r-ver:4.4.1

# Add a non-root user "ubuntu"
RUN useradd -s /bin/bash -m ubuntu \
  && usermod -a -G staff ubuntu
  
# Copy build-scripts into container
COPY build-scripts /tmp/build-scripts

# Install devcontainer features as root
USER root

# common-utils
WORKDIR /tmp/build-scripts/common-utils
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
WORKDIR /tmp/build-scripts/git
RUN VERSION="latest" \
    PPA="true" \
    /bin/bash install.sh

# pandoc
WORKDIR /tmp/build-scripts/pandoc
RUN VERSION="latest" \
  /bin/bash install.sh

# quarto 
WORKDIR /tmp/build-scripts/quarto-cli
RUN VERSION="latest" \
  INSTALLTINYTEX="false" \
  INSTALLCHROMIUM="false" \
  /bin/bash install.sh

# tmux
WORKDIR /tmp/build-scripts/tmux
RUN VERSION="latest" \
  /bin/bash install.sh

# neovim
WORKDIR /tmp/build-scripts/neovim
RUN VERSION="nightly" \
  /bin/bash install.sh

# neofetch
WORKDIR /tmp/build-scripts/neofetch
RUN /bin/bash install.sh

# rstudio-server
WORKDIR /tmp/build-scripts/rstudio-server
RUN VERSION="daily" \
    ALLOWREINSTALL="true" \
    SINGLEUSER="true" \
    USERNAME="ubuntu" \
    /bin/bash install.sh

# Add the start script
RUN /bin/bash -c "cp /tmp/build-scripts/start-rstudio /usr/local/bin/start-rstudio"
RUN /bin/bash -c "chmod 777 /usr/local/bin/start-rstudio"

# Change to non-root user
USER ubuntu
WORKDIR /home/ubuntu

# Add configs
RUN /bin/bash -c "cp /tmp/build-scripts/.lintr ~/.lintr"
RUN /bin/bash -c "cp /tmp/build-scripts/.Rprofile ~/.Rprofile"
RUN /bin/bash -c "cp /tmp/build-scripts/.zshrc ~/.zshrc"
RUN /bin/bash -c "mkdir -p ~/.config/rstudio"
RUN /bin/bash -c "cp /tmp/build-scripts/rstudio-prefs.json ~/.config/rstudio/rstudio-prefs.json"

# tinytex, chromium
RUN /bin/bash -c 'wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh'
RUN /bin/bash -c 'find ~/.TinyTeX/bin/*/* -type f | xargs -I {} sudo ln -s {} /usr/local/bin/'
RUN /bin/bash -c "quarto install chromium"

# R dependencies, radian, and R packages
RUN /bin/bash /tmp/build-scripts/container-setup.sh 2>&1 | tee /tmp/container-setup-log.txt

CMD ["/usr/bin/zsh"]
