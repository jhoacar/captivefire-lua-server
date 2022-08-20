#!/bin/sh

set -eux

FOLDER=$(pwd)/ipk
OUTPUT=$(pwd)/build/captivefire-0.0.1.ipk

rm -rf $OUTPUT

cd $FOLDER/control
tar --numeric-owner --group=0 --owner=0 -czvf ../control.tar.gz ./*

cd $FOLDER/data
tar --numeric-owner --group=0 --owner=0 -czvf ../data.tar.gz ./

cd $FOLDER
echo 2.0 > debian-binary
tar --numeric-owner --group=0 --owner=0 -czvf $OUTPUT debian-binary control.tar.gz data.tar.gz  

rm -rf control.tar.gz data.tar.gz debian-binary