FROM golang:1.14-alpine

# Install requirement
RUN set -xe; \
    apk add --update --no-cache \
        bash \
        bash-completion \
        gcc \
        libc-dev \
        curl \
        openssl \
        git \
        make \
        grep \
        jq \
        autoconf \
        automake \
        libtool \
        gettext \
        gettext-dev \
        g++ \
        texinfo \
    ;

# Fswatch
RUN wget https://github.com/emcrisostomo/fswatch/releases/download/1.14.0/fswatch-1.14.0.tar.gz \
    && tar -xvzf fswatch-1.14.0.tar.gz \
    && cd fswatch-1.14.0/ \
    && ./configure \
    && make \
    && make install;

WORKDIR /var/www/html