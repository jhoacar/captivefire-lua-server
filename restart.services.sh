#!/bin/sh

set -eux

for SERVICE in `cat /app/services`; 
do
    EXISTS=$(find /etc/init.d -iname "$SERVICE")
    [ ! -z "$EXISTS" ] && service $SERVICE restart
done; 

echo "" > '/app/services';