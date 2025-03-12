## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/cellranger
```

Populate `build-scripts/` directory with subdirectories containing installation code for devcontainer features

``` bash
# Ran on 2025-03-11 1:57 PM
bash build-scripts/pull-build-scripts.sh
```

Have a working cellranger binary in the build-scripts too, adjust Dockerfile to this filename

`build-scripts/cellranger-files/cellranger-9.0.1.tar.gz`

Build Docker image

``` bash
# replace `knitz` with your Docker Hub username

# For building local architecture and testing locally
# docker build -t knitz/cellranger:2025-03-11 .
# docker run -it --rm knitz/cellranger:2025-03-11
# docker rmi knitz/cellranger:2025-03-11

# https://docs.docker.com/build/building/multi-platform/
# For building both architectures at the same time and pushing
# Enable containerd image store in settings
  # docker buildx create \
  #   --name container-builder \
  #   --driver docker-container \
  #   --use --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t knitz/cellranger:2025-03-11 --push .

# For building both architectures and storing in tarball
# then loading into docker, then pushing
# docker buildx build --platform linux/amd64,linux/arm64 -t knitz/cellranger:2025-03-11 -o type=docker,dest=cellranger-2025-03-11.tar .
# docker load -i cellranger-2025-03-11.tar
# docker push knitz/cellranger:2025-03-11
```
