#!/bin/sh

echo "" > /app/debug.txt
cp /app/docker/etc/config/uhttpd /app  >> /app/debug.txt 2>&1
rm /app/public/cgi-bin /app/public/luci-static  >> /app/debug.txt 2>&1
opkg update  >> /app/debug.txt 2>&1
opkg install uhttpd luci luci-ssl lpeg lua-cjson lua-openssl luafilesystem luasocket luac make  >> /app/debug.txt 2>&1
opkg install /app/package/captivefire-0.0.1.ipk  >> /app/debug.txt 2>&1
echo "done" >> /app/debug.txt