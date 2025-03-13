## Commands to create and push image

Point working directory to folder where `Dockerfile` and `build-scripts/` exist for this particular build:

``` bash
cd builds/dev
```

Use git to pull external scripts into directory `build-scripts/pulled-scripts`

``` bash
mkdir -p bash-scripts/pulled-scripts
bash pull-scripts.sh
```

Build Docker image

``` bash
# replace `knitz` with your Docker Hub username

# For building local architecture and testing locally
# docker build -t knitz/test:latest .
# docker run -it --rm knitz/test:latest
# docker rmi knitz/test:latest

# https://docs.docker.com/build/building/multi-platform/
# For building both architectures at the same time and pushing
# Enable containerd image store in settings
  # docker buildx create \
  #   --name container-builder \
  #   --driver docker-container \
  #   --use --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t knitz/test:latest --push .

# For building both architectures and storing in tarball
# then loading into docker, then pushing
# docker buildx build --platform linux/amd64,linux/arm64 -t knitz/test:latest -o type=docker,dest=test-latest.tar .
# docker load -i test-latest.tar
# docker push knitz/test:latest
```
