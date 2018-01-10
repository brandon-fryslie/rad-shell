FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y build-essential curl zsh git \
  && useradd --create-home --shell /bin/zsh --groups sudo rad

RUN apt-get install -y sudo docker.io

USER rad
WORKDIR /home/rad

COPY deps/install.sh /tmp/install.sh
COPY deps/rad-init.zsh /tmp/rad-init.zsh
RUN /tmp/install.sh \
  && cp /home/rad/.zshrc /home/rad/.zlogin \
  && zsh -l -c ". ~/.zshrc" \
  && cd /home/rad/.zgen/brandon-fryslie/rad-shell-master \
  && git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'

ARG RAD_SHELL_BRANCH=master
RUN cd /home/rad/.zgen/brandon-fryslie/rad-shell-master \
  && git pull \
  && git checkout $RAD_SHELL_BRANCH
