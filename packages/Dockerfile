FROM openwrtorg/sdk

ENV BUILDER_FOLDER=/home/build/openwrt
ENV PACKAGE_FOLDER=/home/build/packages

COPY . $PACKAGE_FOLDER
COPY ./feeds.conf $BUILDER_FOLDER/feeds.conf

RUN set -eux; 
RUN ./scripts/feeds update mypackages; 
RUN ./scripts/feeds install -a -p mypackages; 
RUN mkdir -p $BUILDER_FOLDER/bin;
RUN sudo chown -R build:build $BUILDER_FOLDER/bin feeds.conf

CMD make package/captivefire/compile -j1 V=sc;