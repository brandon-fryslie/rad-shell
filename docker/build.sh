#!/bin/bash -el

# TODO: copy in test files too

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

trap "rm -rf $script_dir/deps" EXIT

mkdir -p $script_dir/deps

cp $script_dir/../install.sh $script_dir/deps/install.sh
chmod +x $script_dir/deps/install.sh

docker build --tag ${IMAGE_NAME:-rad-shell} $script_dir "$@"
