FROM alpine:3.8

ARG LUFI_VERSION=0.03.3

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
	MAIL_SENDER=no-reply@lufi.io \
    POLICY_WHEN_FULL=warn \
	MAIL_HOW=smtp \
	MAIL_HOWARGS=smtp \
	REPORT=report@example.com

LABEL description="lufi based on alpine" \
      tags="latest" \
      maintainer="xataz <https://github.com/xataz>" \
      build_ver="201807172121" \
      commit="7efebff4bfa3722796a80a783fb332d6e50d41de"

RUN BUILD_DEPS="build-base \
                libressl-dev \
                ca-certificates \
                git \
                tar \
                perl-dev \
                libidn-dev \
                postgresql-dev \
				mariadb-dev \
                wget" \
    && apk add --no-cache ${BUILD_DEPS} \
                libressl \
                perl \
                libidn \
                perl-crypt-rijndael \
                perl-test-manifest \
                perl-net-ssleay \
                tini \
                su-exec \
                postgresql-libs \
				mariadb-dev \
    && echo | cpan \
    && cpan install Carton \
    && git clone https://git.framasoft.org/luc/lufi.git /usr/lufi \
    && cd /usr/lufi \
# checkout a specific tag thanks to https://stackoverflow.com/a/792027/535203
    && git checkout tags/${LUFI_VERSION} -b ${LUFI_VERSION} \
    && rm -rf cpanfile.snapshot \
    && carton install \
    && apk del --no-cache ${BUILD_DEPS} \
    && rm -rf /var/cache/apk/* /root/.cpan* /usr/lufi/local/cache/*
    
VOLUME /usr/lufi/files /usr/lufi/data

EXPOSE 8081

ADD startup /usr/local/bin/startup
ADD lufi.conf /usr/lufi/lufi.conf
RUN chmod +x /usr/local/bin/startup

CMD ["/usr/local/bin/startup"]
