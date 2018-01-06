FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y build-essential curl zsh git \
  && useradd --create-home --shell /bin/zsh --groups sudo rad

RUN apt-get install -y sudo docker.io

USER rad
WORKDIR /home/rad

COPY deps/install.sh /tmp/install.sh
RUN /tmp/install.sh \
  && zsh -l -c ". ~/.zshrc" \
  && rm -rf /home/rad/.zgen/brandon-fryslie/rad-shell-master

COPY deps/rad-shell-master /home/rad/.zgen/brandon-fryslie/rad-shell-master

RUN cat /home/rad/.zgen/brandon-fryslie/rad-shell-master/bin/rad.sh
