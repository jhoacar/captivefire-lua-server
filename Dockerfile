FROM openwrtorg/rootfs:x86-64

ENV PATH_LIB="/usr/share/lua"

# Install Server Dependencies 
RUN mkdir /var/lock && \
    opkg update && opkg install \
    uhttpd \
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

# Install Lapis Dependencies

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
    cp -r /tmp/pgmoon-master/pgmoon $PATH_LIB && \
    cp /tmp/pgmoon-master/pgmoon.lua $PATH_LIB/pgmoon.lua && \
    rm -rf /tmp/master /tmp/pgmoon-master

# Configuration for require folders
RUN ln -s /app/src /usr/lib/lua/captivefire && echo 'return require("captivefire.init")' > /usr/lib/lua/lapis.lua

ARG FOLDER=/app/
ENV FOLDER=$FOLDER

RUN mkdir $FOLDER

# Its necessary a root user for run this container
USER root

WORKDIR $FOLDER

# Using exec format so that /sbin/init is proc 1 (see procd docs)
CMD ["/sbin/init"]