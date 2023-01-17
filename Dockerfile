FROM docker.io/library/debian:11-slim

ENV PORT=3000

RUN apt-get -q update                                                           \
    && DEBIAN_FRONTEND=noninteractive                                           \
    apt-get -q -y install                                                       \
        netcat-openbsd                                                          \
    && apt-get -q clean                                                         \
    && rm -rf /var/lib/apt/lists/*

COPY httpd.sh /usr/local/bin/httpd.sh

CMD ["httpd.sh"]
