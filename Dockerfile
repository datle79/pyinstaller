FROM ubuntu:20.04
SHELL ["/bin/bash", "-i", "-c"]

ENV PYTHON_VERSION=3.8.11
ENV PYINSTALLER_VERSION=3.6
ENV OPENSSL_VERSION=1.1.1m

ENV PYPI_URL=https://pypi.python.org/
ENV PYPI_INDEX_URL=https://pypi.python.org/simple
ENV PYENV_VERSION=${PYTHON_VERSION}
ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

COPY entrypoint.sh /entrypoint.sh

RUN \
    set -x \
    # update system
    && apt-get update \
    # install requirements
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        wget \
        git \
        libbz2-dev \
        libedit-dev \
        libffi-dev \
        liblzma-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libxml2-dev \
        libxmlsec1-dev \
        zlib1g-dev \
        libffi-dev \
        llvm \
        tk-dev \
        xz-utils \
        #optional libraries
        libgdbm-dev \
        libgdbm6 \
        uuid-dev \
        #upx
        upx \

    # required because openSSL on Ubuntu 12.04 and 14.04 run out of support versions of OpenSSL
RUN  mkdir openssl \
    && cd openssl \
    # latest version, there won't be anything newer for this
    && wget https://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz \
    && tar -xzvf openssl-$OPENSSL_VERSION.tar.gz \
    && cd openssl-$OPENSSL_VERSION \
    && ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib \
    && make \
    && make install \

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
    && tar -xf Python-$PYTHON_VERSION.tgz \
    && cd Python-$PYTHON_VERSION \
    && ./configure --prefix=/usr/local --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" --enable-optimizations --enable-shared \
    && make install \
    && ln /usr/local/bin/python3 /usr/local/bin/python  \
    && ln /usr/local/bin/pip3 /usr/local/bin/pip  \
    && pip3 install --upgrade pip \
    # install pyinstaller
    && pip3 install pyinstaller==$PYINSTALLER_VERSION \

RUN mkdir /src/ && chmod +x /entrypoint.sh

VOLUME /src/
WORKDIR /src/

ENTRYPOINT ["/entrypoint.sh"]