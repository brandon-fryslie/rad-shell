This directory contains tests using Google's container structure tests

https://github.com/GoogleCloudPlatform/container-structure-test

https://github.com/nkubala/structure-test-examples

### Getting this to run on macOS

First you need to build the docker image, then you need to compile the test runner.

#### Building the Docker image

Run `./docker-image/build.sh` in this repository.  This will build a docker image
named rad-shell:latest.

#### Compiling Google's container structure test binary

Google's container structure test tool is a go program that must be compiled.

These instructions assume you are on macOS.  If you are running Linux, I
recommend using the instructions in the repository to get the Linux binary.
These instructions should also work on Linux if you tweak some file paths.

This script assumes you have a directory on your $PATH named `/usr/local/bin`.
This should exist if you use Homebrew.

You will need to clone the repository for Google's container structure test
framework and build the binary yourself.  You need to have `golang` installed and
set up correctly.

`git clone https://github.com/GoogleCloudPlatform/container-structure-test`

`cd container-structure-test`

Now we need to install the go dependencies and the Makefile.  This is how I did 
it.  If you know what you are doing with go (I do not), I'm sure this could be improved.

Requires `wgo` and `wgo-exec`: https://github.com/skelterjohn/wgo.

Install wgo: `go get github.com/skelterjohn/wgo`

Install wgo-exec: `go get github.com/skelterjohn/wgo/wgo-exec`

Use wgo to install dependencies from Godeps file: `wgo init && wgo save --godeps && wgo restore`

Run Makefile w/ dependencies installed with wgo: `wgo-exec make cross`

This will create a file in `./out` named `structure-test-darwin-amd64`.

Run `ln -s $(pwd)/out/structure-test-darwin-amd64 /usr/local/bin/structure-test` to symlink the executable to your $PATH.

You can then run `./run.sh` to run the tests.
