FROM openwrtorg/rootfs:x86-64

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
    cp -r /tmp/lapis-master/lapis /usr/lib/lua && \
    echo 'return require("lapis.init")' > /usr/lib/lua/lapis.lua && \
    rm -rf /tmp/master /tmp/lapis-master

# Install Lapis Dependencies

ENV PATH_LIB="/usr/lib/lua"

#Install ansicolors
RUN wget https://raw.githubusercontent.com/kikito/ansicolors.lua/master/ansicolors.lua -O $PATH_LIB/ansicolors.lua;

# Install date
RUN wget https://raw.githubusercontent.com/Tieske/date/master/src/date.lua -O $PATH_LIB/date.lua;

# Install etlua
RUN wget https://raw.githubusercontent.com/leafo/etlua/master/etlua.lua -O $PATH_LIB/etlua.lua;

# Install loadkit
RUN wget https://raw.githubusercontent.com/leafo/loadkit/master/loadkit.lua -O $PATH_LIB/loadkit.lua;

# Install using openwrt package manager
RUN opkg install lpeg lua-cjson luaossl luafilesystem luasocket

# Install pgmoon
RUN wget https://github.com/leafo/pgmoon/archive/refs/heads/master.zip -P /tmp && \
    unzip /tmp/master -d /tmp && \
    cp -r /tmp/pgmoon-master/pgmoon /usr/lib/lua && \
    cp /tmp/pgmoon-master/pgmoon.lua /usr/lib/lua/pgmoon.lua

ARG FOLDER=/app/
ENV FOLDER=$FOLDER

RUN mkdir $FOLDER

# Its necessary a root user for run this container
USER root

WORKDIR $FOLDER

# Using exec format so that /sbin/init is proc 1 (see procd docs)
CMD ["/sbin/init"]