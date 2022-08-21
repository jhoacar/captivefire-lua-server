FROM openwrtorg/rootfs:x86-64

ARG FOLDER=/app/
ENV FOLDER=$FOLDER

RUN mkdir -p $FOLDER

WORKDIR $FOLDER

# Its necessary a root user for run this container
USER root

# Using exec format so that /sbin/init is proc 1 (see procd docs)
CMD ["/sbin/init"]