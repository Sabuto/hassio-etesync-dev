ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH=amd64

ENV LANG C.UTF-8

ENV BASE_DIR /etesync
ENV DATA_DIR /share
ENV STATIC_DIR /var/www/etesync

ENV SECRET_FILE $DATA_DIR/secret.txt
ENV ETESYNC_DB_PATH $DATA_DIR/db.sqlite3
ENV SERVER="http"

WORKDIR $BASE_DIR

ADD https://github.com/etesync/server/archive/master.tar.gz $BASE_DIR

RUN set -e && \
    mkdir -p $BASE_DIR && \
    mkdir -p $DATA_DIR && \
    mkdir -p $STATIC_DIR && \
    tar x -v -z -f $BASE_DIR/master.tar.gz -C /tmp --exclude */example-configs --exclude */.git && \
    mv /tmp/server-master/* $BASE_DIR/ && \
    apk add --no-cache libressl && \
    apk add --no-cache --virtual .buil-deps coreutils gcc make linux-headers libc-dev libressl-dev && \
    pip install -r $BASE_DIR/requirements.txt uwsgi && \
    apk-del .build-deps && \
    $BASE_DIR/manage.py collectstatic && \
    rm $BASE_DIR/master.tar.gz $BASE_DIR/requirements.txt $SECRET_FILE && \
    rm -r /tmp/server-master

COPY run.sh /
RUN chmod a+x /run.sh
COPY telegraf.conf /etc/telegraf/
RUN chmod a+x /etc/telegraf/telegraf.conf

CMD [ "/run.sh" ]
