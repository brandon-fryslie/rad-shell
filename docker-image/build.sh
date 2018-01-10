#!/bin/bash -el

# TODO: copy in test files too

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

trap "rm -rf $script_dir/deps" EXIT

set -x

mkdir -p $script_dir/deps

cp -a $script_dir/../install.sh $script_dir/deps/install.sh
cp -a $script_dir/../rad-init.zsh $script_dir/deps/rad-init.zsh

docker build --tag ${IMAGE_NAME:-rad-shell} "$@" $script_dir
