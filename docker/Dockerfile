FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y build-essential curl zsh git \
  && useradd --create-home --shell /bin/zsh --groups sudo rad

RUN apt-get install -y sudo docker.io

USER rad
WORKDIR /home/rad

COPY deps/install.sh /tmp/install.sh
RUN /tmp/install.sh \
  && zsh -l -c ". ~/.zshrc"
