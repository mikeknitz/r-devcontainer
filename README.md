# r-devcontainer

Documenting my Docker containers here for R development.

<br>

## Available images and usage

- Newer images are cross-platform and toward the top of this list
- For Intel / AMD architecture, use `amd64`
- For ARM or Apple Silicon architecture, use `arm64`

[Available Images](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images)

- [knitz/r-devcontainer:r442-2024-11-04](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr442-2024-11-04)
- [knitz/r-devcontainer:r441-2024-10-25](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr441-2024-10-25)
- [knitz/r-devcontainer:r441-2024-09-23](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr441-2024-09-23)
- [knitz/r-devcontainer:r441-amd64-2024-09-18](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr441-amd64-2024-09-18)
- [knitz/r-devcontainer:r441-arm64-2024-09-18](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr441-arm64-2024-09-18)
- [knitz/r-devcontainer:r441-amd64-2024-09-09](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images#knitzr-devcontainerr441-amd64-2024-09-09)

<br>

## Builds and usage

*Description here relevant to `knitz/r-devcontainer:r442-2024-11-04` and later builds*

Files used to create each image are located in `builds/`. See `build-commands.md` within each build for specific commands run to create each image.

These R images are generally based on Rocker images: <https://rocker-project.org/images/versioned/r-ver.html> with Ubuntu with R already built from source for `linux/amd64` or `linux/arm64` architecture.

The more recent images have RStudio already installed by pulling from `rocker/rstudio` images. These images allow you to run `/init` as root to start RStudio on port 8787 as user `rstudio` using the S6 init system and have it be password protected.

However, for contexts with limited permissions, I've symlinked a script `start-rstudio` to `/usr/local/bin` that manually calls `rserver` and uses the active user to start an RStudio instance without authentication (not secure when the RStudio port is open). See [Available Images](https://github.com/mikeknitz/r-devcontainer/wiki/Available-Images) for usage. Also see `builds/<specific-build>/build-scripts/bin-scripts/start-rstudio`. This script automatically creates/overwrites at `~/.rserver-data/` to provide a reliably writeable location for RStudio server to write to.

Otherwise, call `radian` to start an R session. `~/.Rprofile`, `~/.lintr`, `~/.config/rstudio/rstudio-prefs.json`, and `.zshrc` have been configured for the default user `ubuntu`. See `builds/<specific-build>/build-scripts/dotfiles`. Date-specific repositories from Posit <https://packagemanager.posit.co/> are configured in `~/.Rprofile` for CRAN and Bioconductor repositories.

Devcontainer features (<https://containers.dev/>), are manually implemented (pulled directly from repositories) to setup and install zsh, git, tmux, and neovim. See `builds/<specific-build>/build-scripts/pull-build-scripts.sh`. These are installed earlier in the Dockerfile as root.

I may have less documented / newer images / simple alias images that I'm working on in `knitz/r441:latest`, or `knitz/r442:latest`, etc. See info inside the running container at `/build-scripts/image-info.txt` if necessary. I overwrite these tags.

### Docker tag information

- E.g., `r441` or `r442` for R version 4.4.1 or 4.4.2
- `amd64` or `arm64` for specific architectures. If not present, it is cross-platform.
- Dates: corresponding to the date-specific repositories used from Posit package manager, may not apply to R packages installed from Github or the default R packages in `/usr/local/lib/R/library`.


<br>

<!--

## TODO

- [X] Add `linux/arm64` architecture
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
