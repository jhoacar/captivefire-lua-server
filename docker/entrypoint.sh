#!/bin/sh

set -x

logread -f | strings > /app/debug.txt &

opkg update 
opkg install coreutils-chown
echo "" > /etc/config/wireless
opkg install /app/package/captivefire-0.0.1.ipk 
chown -R 1000:1000 /app
echo "done"