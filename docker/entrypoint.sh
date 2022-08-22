#!/bin/sh

set -x

logread -f > /app/debug.txt &

cp /app/docker/etc/config/uhttpd /app 
rm /app/public/cgi-bin /app/public/luci-static 
opkg update 
opkg install coreutils-chown
opkg install /app/package/captivefire-0.0.1.ipk 
chown -R 1000:1000 /app
echo "done"