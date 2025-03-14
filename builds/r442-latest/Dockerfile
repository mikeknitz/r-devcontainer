FROM knitz/r-devcontainer:r442-2025-03-11

USER root
RUN echo "FROM knitz/r-devcontainer:r442-2025-03-11" > /build-scripts/image-info.txt
RUN chmod 644 /build-scripts/image-info.txt 

USER ubuntu
WORKDIR /home/ubuntu

CMD ["/usr/bin/zsh"]