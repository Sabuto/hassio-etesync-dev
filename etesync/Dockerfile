ARG BUILD_FROM
# hadolint ignore=DL3006
FROM $BUILD_FROM

ARG BUILD_ARCH=amd64

ENV LANG C.UTF-8

ENV BASE_DIR /etesync
ENV DATA_DIR /share
ENV STATIC_DIR /var/www/etesync

ENV SECRET_FILE $DATA_DIR/secret.txt
ENV SERVER="http"

WORKDIR $BASE_DIR

ADD https://github.com/etesync/server/archive/master.tar.gz $BASE_DIR

RUN set -e
RUN mkdir -p $BASE_DIR
RUN mkdir -p $DATA_DIR
RUN mkdir -p $STATIC_DIR
# hadolint ignore=SC2035
RUN tar x -v -z -f $BASE_DIR/master.tar.gz -C /tmp --exclude */example-configs --exclude */.git
RUN mv /tmp/server-master/* $BASE_DIR/
    # hadolint ignore=DL3018
RUN apk add --no-cache libressl
    # hadolint ignore=DL3018
RUN apk add --no-cache --virtual .build-deps coreutils gcc make linux-headers libc-dev libressl-dev
RUN pip install -r $BASE_DIR/requirements.txt uwsgi
RUN apk del .build-deps
RUN $BASE_DIR/manage.py collectstatic
RUN rm $BASE_DIR/master.tar.gz $BASE_DIR/requirements.txt
RUN rm -r /tmp/server-master

COPY run.sh /
RUN chmod a+x /run.sh
COPY etesync.ini /
RUN chmod a+x /etesync.ini
COPY etesync_site_settings.py /
RUN chmod a+x /etesync_site_settings.py

CMD [ "/run.sh" ]
