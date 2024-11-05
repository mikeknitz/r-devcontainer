``` bash
cd builds/r442-latest
```

``` bash
# Testing

# docker build -t knitz/r442:latest .
# docker run -it --rm -p 8787:8787 knitz/r442:latest
# docker rmi knitz/r442:latest .
```

``` bash
# https://docs.docker.com/build/building/multi-platform/
# For building both architectures at the same time and pushing
# Enable containerd image store in settings
  # docker buildx create \
  #   --name container-builder \
  #   --driver docker-container \
  #   --use --bootstrap
docker buildx build --platform linux/amd64,linux/arm64 -t knitz/r442:latest --push .
```
