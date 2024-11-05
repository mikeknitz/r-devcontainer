## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/rsync
```


Build Docker image

``` bash
# replace `knitz` with your Docker Hub username

# For building local architecture and testing locally
# docker build -t knitz/rsync:latest .
# docker run -it --rm knitz/rsync:latest
# docker rmi knitz/rsync:latest

# https://docs.docker.com/build/building/multi-platform/
# For building both architectures at the same time and pushing
# Enable containerd image store in settings
  # docker buildx create \
  #   --name container-builder \
  #   --driver docker-container \
  #   --use --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t knitz/rsync:latest --push .
```
