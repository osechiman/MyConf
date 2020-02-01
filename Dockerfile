FROM ubuntu:18.04
LABEL role=editor

COPY . /root

RUN apt update && \
    apt install -y git tmux less curl neovim

CMD [/bin/bash]
