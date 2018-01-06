#!/bin/bash -el

# TODO: copy in test files too

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

trap "rm -rf $script_dir/deps; rm -rf /tmp/rad-shell-master" EXIT

set -x

mkdir -p $script_dir/deps

cp -a $script_dir/../install.sh $script_dir/deps/install.sh

echo "Script dir $script_dir"
cp -R $script_dir/.. /tmp/rad-shell-master

mv /tmp/rad-shell-master $script_dir/deps/rad-shell-master

docker build --tag ${IMAGE_NAME:-rad-shell} $script_dir "$@"
