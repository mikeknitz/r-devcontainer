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
    
# ssh
RUN /bin/bash -c "apt-get update && DEBIAN_FRONTEND='noninteractive' apt-get install -y \
  openssh-client \
  openssh-server"
EXPOSE 22
  
# Add scripts to /usr/local/bin
  # start-rstudio
  # copy-code-workspace
COPY build-scripts/start-rstudio /build-scripts/start-rstudio
COPY build-scripts/copy-code-workspace /build-scripts/copy-code-workspace
RUN /bin/bash -c "cp /build-scripts/start-rstudio /usr/local/bin/start-rstudio"
RUN /bin/bash -c "chmod 777 /usr/local/bin/start-rstudio"
RUN /bin/bash -c "cp /build-scripts/copy-code-workspace /usr/local/bin/copy-code-workspace"
RUN /bin/bash -c "chmod 777 /usr/local/bin/copy-code-workspace"

# Change to non-root user
USER ubuntu
WORKDIR /home/ubuntu

# Add configs
COPY build-scripts/.lintr /build-scripts/.lintr
COPY build-scripts/.Rprofile /build-scripts/.Rprofile
COPY build-scripts/.zshrc /build-scripts/.zshrc
COPY build-scripts/rstudio-prefs.json /build-scripts/rstudio-prefs.json
RUN /bin/bash -c "cp /build-scripts/.lintr ~/.lintr"
RUN /bin/bash -c "cp /build-scripts/.Rprofile ~/.Rprofile"
RUN /bin/bash -c "cp /build-scripts/.zshrc ~/.zshrc"
RUN /bin/bash -c "mkdir -p ~/.config/rstudio"
RUN /bin/bash -c "cp /build-scripts/rstudio-prefs.json ~/.config/rstudio/rstudio-prefs.json"

CMD ["/usr/bin/zsh"]
