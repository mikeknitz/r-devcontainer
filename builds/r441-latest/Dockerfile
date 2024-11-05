FROM knitz/r-devcontainer:r441-2024-10-25

USER root
RUN echo "FROM knitz/r-devcontainer:r441-2024-10-25" > /build-scripts/image-info.txt
RUN chmod 644 /build-scripts/image-info.txt 

USER ubuntu
WORKDIR /home/ubuntu

CMD ["/usr/bin/zsh"]