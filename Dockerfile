FROM alpine:3

ARG LUFI_VERSION=0.04.2

ENV GID=991 \
    UID=991 \
    SECRET=0423bab3aea2d87d5eedd9a4e8173618 \
    CONTACT=contact@domain.tld \
    MAX_FILE_SIZE=1000000000 \
    WEBROOT=/ \
    DEFAULT_DELAY=1 \
    MAX_DELAY=0 \
    THEME=default \
    ALLOW_PWD_ON_FILES=1 \
    POLICY_WHEN_FULL=warn

LABEL description="lufi based on alpine" \
      tags="latest 0.04.2 0.03.5 0.03" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201909260845"

RUN apk add --update --no-cache --virtual .build-deps \
                build-base \
                libressl-dev \
                ca-certificates \
                git \
                tar \
                perl-dev \
                libidn-dev \
                postgresql-dev \
                wget \
    && apk add --update --no-cache \
                libressl \
                perl \
                libidn \
                perl-crypt-rijndael \
                perl-test-manifest \
                perl-net-ssleay \
                tini \
                su-exec \
                postgresql-libs \
    && echo | cpan \
    && cpan install Carton \
    && git clone -b ${LUFI_VERSION} https://framagit.org/luc/lufi.git /usr/lufi \
    && cd /usr/lufi \
    && echo "requires 'Mojo::mysql';" >> /usr/lufi/cpanfile \
    && rm -rf cpanfile.snapshot \
    && carton install \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lufi/local/cache/*

VOLUME /usr/lufi/data /usr/lufi/files

EXPOSE 8081

COPY startup /usr/local/bin/startup
COPY lufi.conf /usr/lufi/lufi.conf
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]
