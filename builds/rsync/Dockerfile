FROM ubuntu:22.04

RUN DEBIAN_FRONTEND="noninteractive" apt-get update \
  && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
    openssh-client \
    openssh-server \
    rsync \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]