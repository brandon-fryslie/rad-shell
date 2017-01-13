#!/usr/bin/env bash

if [[ ! "$(uname)" == Darwin ]]; then
  echo "This script is only applicable for macOS"
  exit 1
fi

if ! which brew; then
  echo "Homebrew is not installed.  Please install that first."
  echo "http://brew.sh"
  exit 1
fi

brew install tmux
brew install ack
brew install reattach-to-user-namespace
pip install powerline-status
pip install psutil
