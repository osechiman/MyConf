FROM ubuntu:18.04
LABEL role=editor

SHELL ["/bin/bash", "-c"]
WORKDIR /root

COPY .bashrc /root
COPY .vimrc /root
COPY .vim /root/.vim

RUN apt-get update && \
    apt-get install -y git tmux less curl vim binutils bison gcc make build-essential cmake python3-dev

RUN curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash && \
    source /root/.gvm/scripts/gvm && \
    gvm install go1.4 -B && \
    gvm use go1.4 && \
    export GOROOT_BOOTSTRAP=$GOROOT && \
    gvm install go1.13 -B && \
    gvm use go1.13 --default
