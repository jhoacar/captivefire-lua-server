#!/bin/bash

BUILDER_FOLDER=/home/build/openwrt
PACKAGE_FOLDER=/home/build/packages

docker run --rm -it -v $(pwd):$PACKAGE_FOLDER -v $(pwd)/feeds.conf:$BUILDER_FOLDER/feeds.conf openwrtorg/sdk bash

# ./scripts/feeds update mypackages
# ./scripts/feeds install -a -p mypackages
# make menuconfig
# make package/captivefire/compile
# cp -r bin/packages/* /home/build/packages/build
exit 0