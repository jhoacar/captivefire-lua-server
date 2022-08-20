#!/bin/bash

set -eux

BUILDED=/home/build/openwrt/bin/packages
IMAGE=captivefire:package-builder

docker build -f packages/Dockerfile -t $IMAGE packages

docker run --rm -it -v $(pwd)/packages/build:$BUILDED $IMAGE make package/captivefire/compile