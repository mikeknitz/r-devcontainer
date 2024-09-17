# r-devcontainer

Documenting my Docker containers here for R development.

## Usage

Pull container from Docker Hub

``` bash
# Pull image
docker pull knitz/r-devcontainer:r441-amd64-2024-09-09
```

### From terminal

Starting containers from image

- `--name` = name of created container
- `-v` = bind mounting `host_dir:container_dir`
- `-w` = initial working directory in container
- `-p` = port mapping `host:container`
- `-d` = detached container running in background
  - Can attach a terminal with `docker exec <container-id> zsh`
- `-it` = Attach an interactive terminal
- `--rm` = Automatically stop & delete container when all terminals / processes done

``` bash
# Run disposable container in background with rserver running
# `docker stop <container-id>` when done to stop & remove container
docker run -d --rm \
  -v "$(pwd):/workspaces/$(basename $(pwd))" \
  -w /workspaces/$(basename $(pwd)) \
  -p 8787:8787 \
  knitz/r-devcontainer:r441-amd64-2024-09-09 \
  start-rstudio

# Run disposable container and open up a terminal
# Run `start-rstudio` to start rserver
# Kill terminal to stop and delete container
docker run -it --rm \
  -v "$(pwd):/workspaces/$(basename $(pwd))" \
  -w /workspaces/$(basename $(pwd)) \
  -p 8787:8787 \
  knitz/r-devcontainer:r441-amd64-2024-09-09

# Run named, persistent container in background with rserver running
# `docker stop <container-id>` when done to stop
# `docker start <container-id>` to start it again
# `docker rm <container-id>` to delete container
docker run -d \
  --name "my-container" \
  -v "$(pwd):/workspaces/$(basename $(pwd))" \
  -w /workspaces/$(basename $(pwd)) \
  -p 8787:8787 \
  knitz/r-devcontainer:r441-amd64-2024-09-09 start-rstudio

# Run named, persistent container and open up a terminal
# Run `start-rstudio` to start rserver
# Container will stop when all terminals are exited or use `docker stop`
# `docker start <container-id>` to start it again
# `docker rm <container-id>` to delete container
docker run -it \
  --name "my-container" \
  -v "$(pwd):/workspaces/$(basename $(pwd))" \
  -w /workspaces/$(basename $(pwd)) \
  -p 8787:8787 \
  knitz/r-devcontainer:r441-amd64-2024-09-09
```

### From VS Code

Using Dev Containers extension, add a `devcontainer.json` specification then VS Code command: `Dev Containers: Reopen in Container`, this should drop you in the container with the host's working directory mounted inside of `/workspaces`.

``` bash
# In project directory
mkdir .devcontainer
touch .devcontainer/devcontainer.json
```

`.devcontainer/devcontainer.json`

- `name`: Name that appears in VS Code
- `image`: image:tag to build container from
- `runArgs`: The --name argument will appear in list of docker containers when running `docker ps -a`. Port mapping seems to be done automagically in VS Code but you can specify here e.g., if running in terminal outside of VS Code.
- `customizations`: VS Code extensions to install by default inside of container
- `mounts`: Bind mounts, in addition to working directory from host
- `remoteUser`: User to connect as


``` json
{
  "name": "name-of-container",
  "image": "image:tag",
  "runArgs": ["--name", "name-of-container-in-docker", "-p", "8787:8787"],
  "customizations": {
    "vscode": {
      "settings": {},
      "extensions": [
        "reditorsupport.r",
        "rdebugger.r-debugger"
      ]
    }
  },
  "mounts": [
    {
      "source": "/path/to/dir/on/host",
      "target": "/path/to/dir/in/container",
      "type": "bind"
    }
  ],
  "remoteUser": "ubuntu"
}
```

## Available images

- See [Available Images](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images)

## Build documentation

This section details build: `knitz/r-devcontainer:r441-amd64-2024-09-09`

This image is based on `rocker/r-ver`: <https://rocker-project.org/images/versioned/r-ver.html> with Ubuntu 22.04 with R already built from source for `linux/amd64` or `linux/arm64` architecture.

### devcontainer Features

I've made use of "devcontainer" features: <https://containers.dev/>. However, these are generally made to be installed over an image during container build. Instead, `build-scripts/pull-build-scripts.sh` is run before the `docker build` step to populate `build-scripts/` with code from several features, essentially baking these features into the image, rather than their intended use installing on the fly. The `Dockerfile` will then copy these scripts into the image during the build step and use them to build each feature.

Most of the devcontainer features will generally have a simple `install.sh` script, however, others might use special features in the Dev Container CLI (<https://github.com/devcontainers/cli>), for example scripts run at container creation time (onCreate) or after a feature has attached (postAttachCommand). Any functionality with these special parameters is instead adapted manually into the image itself or as parameters to a `docker run` command, etc. E.g., see `oncreate.sh` [here](https://github.com/rocker-org/devcontainer-features/blob/main/src/rstudio-server/oncreate.sh).

With an image that already has useful features built in, there's no need to wait for the devcontainer CLI to install features, at the expense of some upfront configuration and image building. It's also useful for adapting docker images as Apptainer / Singularity images but retaining the functionality of the devcontainer features.

### Pull build scripts from repositories

Currently pulling these features into the image:

- [features/src/common-utils at main · devcontainers/features · GitHub](https://github.com/devcontainers/features/tree/main/src/common-utils)
- [features/src/git at main · devcontainers/features · GitHub](https://github.com/devcontainers/features/tree/main/src/git)
- [devcontainer-features/src/pandoc at main · rocker-org/devcontainer-features · GitHub](https://github.com/rocker-org/devcontainer-features/tree/main/src/pandoc)
- [devcontainer-features/src/quarto-cli at main · rocker-org/devcontainer-features · GitHub](https://github.com/rocker-org/devcontainer-features/tree/main/src/quarto-cli)
- [devcontainer-features/src/rstudio-server at main · rocker-org/devcontainer-features · GitHub](https://github.com/rocker-org/devcontainer-features/tree/main/src/rstudio-server)
- [devcontainer-features/src/neovim at main · duduribeiro/devcontainer-features · GitHub](https://github.com/duduribeiro/devcontainer-features/tree/main/src/neovim)
- [devcontainer-features/src/tmux at main · duduribeiro/devcontainer-features · GitHub](https://github.com/duduribeiro/devcontainer-features/tree/main/src/tmux)
- and just for fun: [features/src/neofetch at main · devcontainers-contrib/features · GitHub](https://github.com/devcontainers-contrib/features/tree/main/src/neofetch)

This script pulls from the respective GitHub repositories, and the features are tied to specific commits so that they are robust to any feature updates.

``` bash
# Populate build-scripts/ directory with subdirectories for each feature
bash build-scripts/pull-build-scripts.sh
```

### Build Docker image from Dockerfile

For tags, I'm adding this info:

- R version: e.g., r441 for R 4.4.1. These are limited to what I'm able to pull from `rocker/r-ver`.
- Platform: Until I figure out making any images cross-platform, I'm adding either amd64 or arm64 corresponding to the architecture (only these two are available in `rocker/r-ver`).
- Dates: corresponding to availability from Posit Package Manger for CRAN and Bioconductor packages. These lock in package versions to those that were available on a certain date. Currently I have R packages `httpgd` ([GitHub - nx10/httpgd: Asynchronous http server graphics device for R.](https://github.com/nx10/httpgd)) and `presto` ([GitHub - immunogenomics/presto: Fast Wilcoxon and auROC](https://github.com/immunogenomics/presto)) as just installing the latest version, not from a specific date.

``` bash
# Build
docker build -t r-devcontainer:r441-amd64-2024-09-09 .
```

### Push to Docker Hub

Tag the image prepended with Docker Hub username, then push

``` bash
docker tag r-devcontainer:r441-amd64-2024-09-09 <docker-hub-username>/r-devcontainer:r441-amd64-2024-09-09
docker push <docker-hub-username>/r-devcontainer:r441-amd64-2024-09-09
```

### Summary of Dockerfile commands

- Pull base Ubuntu image with R built in
- Add non-root user "ubuntu"
- Copy `build-scripts/` to `/tmp/build-scripts/` inside the image
- Run devcontainer feature scripts as the root user
- Copy in files and configs:
  - A helper script `start-rstudio` to launch a RStudio Server instance
  - `.lintr`, `.Rprofile`, `.zshrc`, `rstudio-prefs.json`
- Install:
  - TinyTeX (through <https://yihui.org/tinytex/>)
  - Chromium (through `quarto install`)
- Run `container-setup.sh`:
  - Install system dependencies with `apt-get`
  - Install radian terminal [GitHub - randy3k/radian: A 21 century R console](https://github.com/randy3k/radian)
  - Install and configure fonts with `ttf-mscorefonts-installer` <https://packages.debian.org/sid/fonts/ttf-mscorefonts-installer>
  - Install CRAN and Bioconductor packages (see `build-scripts/container-setup.sh`)
  - Import fonts to R with `extrafont` package: [CRAN: Package extrafont](https://cran.r-project.org/web/packages/extrafont/index.html)
- End with `CMD ["/usr/bin/zsh"]` (configured as the non-root users's default shell)

## TODO

- [ ] Add `linux/arm64` architecture
- [ ] Add logs to note final container specification
- [ ] Document dotfile integration / installation from host
- [ ] Document usage with devcontainer CLI
- [ ] Document usage with Windows / WSL
- [ ] Document usage with Singularity / Apptainer / HPC
- [ ] Lock the last few R packages installed through GitHub to specific dates
- [ ] Refactor build process to have configurable options so that images can easily be built on the fly
- [ ] Add options for minimally sized container without devcontainer features baked in
- [ ] Add options for R package installation
- [ ] Add options for RStudio configuration
- [ ] Add support for [renv](https://rstudio.github.io/renv/)
- [ ] Add support for [shiny](https://shiny.posit.co/)
