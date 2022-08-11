FROM openwrtorg/rootfs:x86-64

ENV PATH_LIB="/usr/share/lua"

# Install Server Dependencies 
RUN mkdir /var/lock && \
    opkg update && opkg install \
    uhttpd \
    uhttpd-mod-lua \
    luci \
    luci-ssl

# Install Lapis

RUN opkg install unzip && \ 
    wget https://github.com/leafo/lapis/archive/refs/heads/master.zip -P /tmp && \
    unzip /tmp/master -d /tmp && \
    mkdir -p $PATH_LIB && \
    cp -r /tmp/lapis-master/lapis $PATH_LIB && \
    echo 'return require("lapis.init")' > $PATH_LIB/lapis.lua && \
    rm -rf /tmp/master /tmp/lapis-master

# Install NGINX Adapter

RUN wget https://github.com/jhoacar/uhttpd-ngx-lua-adapter/archive/refs/heads/master.zip -P /tmp && \
    unzip /tmp/master -d /tmp && \
    mkdir -p $PATH_LIB/nginx && \
    cp -r /tmp/uhttpd-ngx-lua-adapter-master/uhttpd $PATH_LIB/nginx && \
    rm -rf /tmp/master /tmp/uhttpd-ngx-lua-adapter-master

# Install Lapis Dependencies

#Install ansicolors
RUN wget https://raw.githubusercontent.com/kikito/ansicolors.lua/master/ansicolors.lua -O $PATH_LIB/ansicolors.lua;

# Install date
RUN wget https://raw.githubusercontent.com/Tieske/date/master/src/date.lua -O $PATH_LIB/date.lua;

# Install etlua
RUN wget https://raw.githubusercontent.com/leafo/etlua/master/etlua.lua -O $PATH_LIB/etlua.lua;

# Install loadkit
RUN wget https://raw.githubusercontent.com/leafo/loadkit/master/loadkit.lua -O $PATH_LIB/loadkit.lua;

# Install openresty for multipart form data
RUN mkdir -p $PATH_LIB/resty && wget https://raw.githubusercontent.com/openresty/lua-resty-upload/master/lib/resty/upload.lua -O $PATH_LIB/resty/upload.lua

# Install using openwrt package manager
RUN opkg install lpeg lua-cjson luaossl luafilesystem luasocket

# Configuration for require folders
RUN ln -s /app/src /usr/lib/lua/captivefire && echo 'return require("captivefire.init")' > /usr/lib/lua/lapis.lua

# Configuration for views
RUN ln -s /app/src/views /usr/lib/lua/views


ARG FOLDER=/app/
ENV FOLDER=$FOLDER

RUN mkdir $FOLDER

# Its necessary a root user for run this container
USER root

WORKDIR $FOLDER

# Using exec format so that /sbin/init is proc 1 (see procd docs)
CMD ["/sbin/init"]