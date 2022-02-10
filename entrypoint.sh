#!/usr/bin/env bash

# Fail on errors.
set -e

# Make sure .bashrc is sourced
. /root/.bashrc

# enable env workdir
WORKDIR=${SRCDIR:-/src}

#
# allow custom PyPi configs
#
if [[ "$PYPI_URL" != "https://pypi.python.org/" ]] || \
   [[ "$PYPI_INDEX_URL" != "https://pypi.python.org/simple" ]]; then
    mkdir -p /root/.pip
    echo "[global]" > /root/.pip/pip.conf
    echo "index = $PYPI_URL" >> /root/.pip/pip.conf
    echo "index-url = $PYPI_INDEX_URL" >> /root/.pip/pip.conf
    echo "trusted-host = $(echo $PYPI_URL | perl -pe 's|^.*?://(.*?)(:.*?)?/.*$|$1|')" >> /root/.pip/pip.conf

    echo "Using custom pip.conf: "
    cat /root/.pip/pip.conf
fi

cd $WORKDIR

if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi # [ -f requirements.txt ]

echo "$@"

if [[ "$@" == "" ]]; then
    pyinstaller --clean -y --dist ./dist/linux --workpath /tmp *.spec
    chown -R --reference=. ./dist/linux
else
    sh -c "$@"
fi # [[ "$@" == "" ]]