## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/r-devcontainer-r442-2024-11-04
```

Populate `build-scripts/` directory with subdirectories containing installation code for devcontainer features

``` bash
# Ran on 2024-11-05
bash build-scripts/pull-build-scripts.sh
```

Build Docker image

``` bash
# replace `knitz` with your Docker Hub username

# For building local architecture and testing locally
# docker build -t knitz/r-devcontainer:r442-2024-11-04 .
# docker run -it --rm knitz/r-devcontainer:r442-2024-11-04
# docker rmi knitz/r-devcontainer:r442-2024-11-04

# https://docs.docker.com/build/building/multi-platform/
# For building both architectures at the same time and pushing
# Enable containerd image store in settings
  # docker buildx create \
  #   --name container-builder \
  #   --driver docker-container \
  #   --use --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t knitz/r-devcontainer:r442-2024-11-04 --push .

# For building both architectures and storing in tarball
# then loading into docker, then pushing
# docker buildx build --platform linux/amd64,linux/arm64 -t knitz/r-devcontainer:r442-2024-11-04 -o type=docker,dest=r-devcontainer-r442-2024-11-04.tar .
# docker load -i r-devcontainer-r442-2024-11-04.tar
# docker push knitz/r-devcontainer:r442-2024-11-04
```
