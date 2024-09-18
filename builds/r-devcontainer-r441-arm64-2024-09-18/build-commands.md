## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/r-devcontainer-r441-arm64-2024-09-18
```

Populate `build-scripts/` directory with subdirectories containing installation code for devcontainer features

``` bash
bash build-scripts/pull-build-scripts.sh
```

Build Docker image

``` bash
docker build -t r-devcontainer:r441-amd64-2024-09-09 .
```

Push to Docker Hub

``` bash
docker login
docker tag r-devcontainer:r441-amd64-2024-09-09 <docker-hub-username>/r-devcontainer:r441-amd64-2024-09-09
docker push <docker-hub-username>/r-devcontainer:r441-amd64-2024-09-09
```

## Summary of build

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
