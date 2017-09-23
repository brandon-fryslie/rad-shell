FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y build-essential curl zsh git \
  && useradd --create-home --shell /bin/zsh --groups sudo rad

RUN apt-get install -y sudo docker.io

USER rad
WORKDIR /home/rad

RUN curl -o- https://raw.githubusercontent.com/brandon-fryslie/rad-shell/master/install.sh | bash \
  && zsh -l -c ". ~/.zshrc"

COPY files/zshrc $HOME/.zshrc
COPY files/zgen-setup.zsh $HOME/.zgen-setup.zsh
