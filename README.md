# r-devcontainer

Documenting my Docker containers here for R development.

<br>

## Available images and usage

- [Available Images](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images)
    - [knitz/r-devcontainer:r441-amd64-2024-09-09](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr441-amd64-2024-09-09)

<br>

## Build documentation for R Containers

Files used to create each image are located in `builds/`.

See `build-commands.md` within each build for specific commands run to create each image.

### Base image

These R images are generally based on `rocker/r-ver`: <https://rocker-project.org/images/versioned/r-ver.html> with Ubuntu (generally 22.04 "Jammy") with R already built from source for `linux/amd64` or `linux/arm64` architecture.

### devcontainer "features"

I've made use of "devcontainer" features: <https://containers.dev/>. However, these are generally made to be installed on top of an existing image during container build. Instead, here, `build-scripts/pull-build-scripts.sh` is run before the `docker build` step to populate a `build-scripts/` with code from several features, essentially baking these features into the image, rather than their intended use installing on the fly. The `Dockerfile` will then copy these scripts into the image during the build step and use them to build each feature.

Most of the devcontainer features will generally have a simple `install.sh` script, however, others might use special features in the Dev Container CLI (<https://github.com/devcontainers/cli>), for example scripts run at container creation time (onCreate) or after a feature has attached (postAttachCommand). Any functionality with these special parameters is instead adapted manually into the image itself or as parameters to a `docker run` command, etc. E.g., see `oncreate.sh` [here](https://github.com/rocker-org/devcontainer-features/blob/main/src/rstudio-server/oncreate.sh).

With an image that already has useful features built in (instead of installed on container creation time), there's no need to wait for the devcontainer CLI to install features, at the expense of some upfront configuration and image building. It's also useful for adapting docker images as Apptainer / Singularity images but retaining the functionality of the devcontainer features.

This script pulls from the respective GitHub repositories, and the features are tied to specific commits so that they are robust to any feature updates.

### Additional setup and R packages

- `.Rprofile` is added and configures date-specific repositories: <https://packagemanager.posit.co/>
- `rstudio-prefs.json` is added for intial RStudio settings
- `container-setup.sh` is called by the Dockerfile to install additional system dependencies and install R packages

### Tags

For Docker tags, I'm adding this info:

- R version: e.g., r441 for R 4.4.1. These are limited to what I'm able to pull from `rocker/r-ver`.
- Platform: Either amd64 or arm64 corresponding to the architecture (only these two are available in `rocker/r-ver`).
- Dates: corresponding to availability from Posit Package Manger for CRAN and Bioconductor packages. These lock in package versions to those that were available on a certain date.

<br>

<!--

## TODO

- [ ] Add `linux/arm64` architecture
- [ ] Add logs to note final container specification
- [ ] Document dotfile integration / installation from host
- [ ] Document usage with devcontainer CLI
- [ ] Document usage with Windows / WSL
- [ ] Document usage with Singularity / Apptainer / HPC
- [x] Lock the last few R packages installed through GitHub to specific commits
- [ ] Refactor build process to have configurable options
- [ ] Add options for minimally sized container to run a script non-interactively
- [ ] Try to optimize container size a bit anyway otherwise
- [ ] Add options for R package installation
- [ ] Add options for RStudio configuration
- [ ] Add options/support for [renv](https://rstudio.github.io/renv/)
- [ ] Add options/support for [shiny](https://shiny.posit.co/)

-->
