#!/bin/sh

echo "" > /app/debug.txt
cp /app/docker/etc/config/uhttpd /app  >> /app/debug.txt 2>&1
rm /app/public/cgi-bin /app/public/luci-static  >> /app/debug.txt 2>&1
opkg update  >> /app/debug.txt 2>&1
opkg install coreutils-chown >> /app/debug.txt 2>&1
opkg install /app/package/captivefire-0.0.1.ipk  >> /app/debug.txt 2>&1
chown -R 1000:1000 /app >> /app/debug.txt 2>&1
echo "done" >> /app/debug.txt