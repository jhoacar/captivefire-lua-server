#!/usr/bin/env sh
echo "Status: 200 OK\r\n"
echo "Content-type: text/html"
echo ""
echo '<html>'
echo '<head>'
echo '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
echo '<title>System Uptime</title>'
echo '</head>'
echo '<body>'
for i in $(printenv); #accessing each environment variable  
do  
echo "$i<br>"  
done 
echo '<h3>'
while read line
do
  echo "$line"
done < "${1:-/dev/stdin}"
echo '</h3>'
echo '<h3>'
hostname
echo '</h3>'

uptime

echo '<form method="POST" enctype="multipart/form-data"><input name="mensaje" value="ey"><input type="file" name="archivo"><input type="submit" value="send"></form>'

exit 0
