FROM ubuntu:18.04
LABEL role=editor

SHELL ["/bin/bash", "-c"]
WORKDIR /root

COPY .bashrc /root
COPY .vimrc /root
COPY .vim /root/.vim

RUN apt update && \
    apt install -y git tmux less curl binutils bison gcc make build-essential cmake python3-dev gettext libtinfo-dev libacl1-dev libgpm-dev lua5.2 liblua5.2-dev

RUN git clone https://github.com/vim/vim.git && cd vim && ./configure --enable-python3interp --enable-luainterp --enable-fail-if-missing && make install && cd ../ && rm -rf vim

RUN curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash && \
    source /root/.gvm/scripts/gvm && \
    gvm install go1.4 -B && \
    gvm use go1.4 && \
    export GOROOT_BOOTSTRAP=$GOROOT && \
    gvm install go1.13 -B && \
    gvm use go1.13 --default
