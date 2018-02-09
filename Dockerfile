FROM node:6

ARG PARSOID_VERSION=v0.8.0
ENV WORKDIR /usr/src/parsoid
WORKDIR $WORKDIR
EXPOSE 8000

##############################
#
# general utilities
#
##############################
RUN apt-get update
RUN apt-get -y install nano
RUN apt-get -y install vim
RUN apt-get -y install net-tools
RUN apt-get -y install zip
RUN apt-get -y install curl


##############################
#
# Parsoid
#
##############################

RUN set -x; \
    git clone \
      --depth 1 \
      -b ${PARSOID_VERSION} \
      https://github.com/wikimedia/parsoid \
      $WORKDIR \
    && rm -rf $WORKDIR/.git/

RUN npm install && npm cache clean --force

RUN mkdir -p /data
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
