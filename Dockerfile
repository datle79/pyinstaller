FROM ubuntu:20.04

ARG PYINSTALLER_VERSION=4.9


ENV PYPI_URL=https://pypi.python.org/
ENV PYPI_INDEX_URL=https://pypi.python.org/simple
ENV PYENV_VERSION=${PYTHON_VERSION}

COPY entrypoint.sh /entrypoint.sh

RUN \
    set -x \
    && apt-get update \
    && apt-get install -y \
        build-essential \
        ca-certificates \
        curl \
        wget \
        git \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        zlib1g-dev \
        libffi-dev \
        upx \
        python3 \
        python3-pip \
        openssl \
    # install pyinstaller
    && pip3 install pyinstaller==$PYINSTALLER_VERSION \
    && mkdir /src/ \
    && chmod +x /entrypoint.sh

VOLUME /src/
WORKDIR /src/

ENTRYPOINT ["/entrypoint.sh"]
