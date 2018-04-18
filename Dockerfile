FROM node:6

LABEL Description="This image is used to start parsoid" Vendor="Museum für Naturkunde Berlin" Version="0.3"

ARG PARSOID_VERSION=v0.8.0
ENV WORKDIR /usr/src/parsoid
WORKDIR $WORKDIR
EXPOSE 8000

##############################
#
# general utilities
#
##############################
RUN apt-get update \
    && apt-get -y install nano vim net-tools zip curl \
    && apt-get clean \
    \
##############################
#
# Parsoid
#
##############################
    && set -x \
    && git clone \
      --depth 1 \
      -b ${PARSOID_VERSION} \
      https://github.com/wikimedia/parsoid \
      $WORKDIR \
    && rm -rf $WORKDIR/.git/ \
    \
    && npm install && npm cache clean --force \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    \
    && mkdir -p /data

VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
