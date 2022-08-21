#!/bin/sh

set -eux

ROOT=$(pwd)
FOLDER=$ROOT/ipk
DATA=$FOLDER/data

OUTPUT=$ROOT/build/captivefire-0.0.1.ipk

rm -rf $DATA/*
# -------------- Adding files ------------------------

cd $DATA
mkdir -p etc app root

cd $DATA/etc
mkdir -p config crontabs

cd $DATA/app
mkdir -p build public

cd $DATA/root
mkdir -p .ssh


cp $ROOT/docker/etc/config/uhttpd $DATA/app
cp $ROOT/docker/etc/crontabs/root $DATA/etc/crontabs
cp $ROOT/docker/root/ssh/id_rsa_captivefire.pub $DATA/root/.ssh

cp -r $ROOT/lua_modules $DATA/app
cp $ROOT/build/captivefire.luac $DATA/app/build
cp $ROOT/public/index.lua $DATA/app/public
cp $ROOT/restart.services.sh $DATA/app

# -------------- Start Building ----------------------
rm -rf $OUTPUT

cd $FOLDER/control
tar --numeric-owner --group=0 --owner=0 -czvf ../control.tar.gz ./*

cd $DATA
tar --numeric-owner --group=0 --owner=0 -czvf ../data.tar.gz ./

cd $FOLDER
echo 2.0 > debian-binary
tar --numeric-owner --group=0 --owner=0 -czvf $OUTPUT debian-binary control.tar.gz data.tar.gz  

rm -rf $FOLDER/control.tar.gz $FOLDER/data.tar.gz $FOLDER/debian-binary $DATA/*