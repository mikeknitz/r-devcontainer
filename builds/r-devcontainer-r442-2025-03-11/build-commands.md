## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/r-devcontainer-r442-2025-03-11
```

Use git to pull external scripts into directory `build-scripts/pulled-scripts`

``` bash
# Run 2025-03-12
mkdir -p bash-scripts/pulled-scripts
bash pull-scripts.sh
```

Check values for:

- Mirror URLs for these options in `build-scripts/dotfiles/.Rprofile`
  - repos
  - BioC_mirror
  - BIOCONDUCTOR_CONFIG_FILE
- Commits used for GitHub-installed packages in `Dockerfile`
- For source installs of R packages, point the repo toward the POSIT URL that only hosts the source installs
  - e.g., SOURCE: `https://packagemanager.posit.co/cran/2025-03-11`
    - This forces a source install
  - e.g., BINARY: `https://packagemanager.posit.co/cran/__linux__/noble/2025-03-11`
    - This one allows binary installs and is used in `~/.Rprofile`

Build Docker image

``` bash
# replace `knitz` with your Docker Hub username

# For building local architecture and testing locally
# docker build -t knitz/r-devcontainer:r442-2025-03-11 .
# docker run -it --rm knitz/r-devcontainer:r442-2025-03-11
# docker rmi knitz/r-devcontainer:r442-2025-03-11

# https://docs.docker.com/build/building/multi-platform/
# For building both architectures at the same time and pushing
# Enable containerd image store in settings
  # docker buildx create \
  #   --name container-builder \
  #   --driver docker-container \
  #   --use --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t knitz/r-devcontainer:r442-2025-03-11 --push .

# For building both architectures and storing in tarball
# then loading into docker, then pushing
# docker buildx build --platform linux/amd64,linux/arm64 -t knitz/r-devcontainer:r442-2025-03-11 -o type=docker,dest=r-devcontainer-r442-2025-03-11.tar .
# docker load -i r-devcontainer-r442-2025-03-11.tar
# docker push knitz/r-devcontainer:r442-2025-03-11
```
