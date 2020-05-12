#!/bin/bash
# AYA build script for Ubuntu & Debian 9 v.3 (c) Decker (and webworker)
# Modifiled for Debian 10 by gcharang

set -euxo pipefail
#set -e

berkeleydb() {
    AYA_ROOT=$(pwd)
    AYA_PREFIX="${AYA_ROOT}/db4"
    mkdir -p $AYA_PREFIX
    wget -N 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef db-4.8.30.NC.tar.gz' | sha256sum -c
    tar -xzvf db-4.8.30.NC.tar.gz
    sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-4.8.30.NC/dbinc/atomic.h
    cd db-4.8.30.NC/build_unix/
    ../dist/configure -enable-cxx -disable-shared -with-pic -prefix=$AYA_PREFIX
    make install
    cd $AYA_ROOT
}
buildAYA() {
    git pull
    ./autogen.sh
    ./configure LDFLAGS="-L${AYA_PREFIX}/lib/" CPPFLAGS="-I${AYA_PREFIX}/include/" --with-gui=no --disable-tests --disable-bench --without-miniupnpc --enable-experimental-asm --enable-static --disable-shared --with-incompatible-bdb
    make -j$(nproc)
}
berkeleydb
buildAYA
echo "Done building AYA!"
sudo ln -sf /home/$USER/AYAv2/src/aryacoin-cli /usr/local/bin/aryacoin-cli
sudo ln -sf /home/$USER/AYAv2/src/aryacoind /usr/local/bin/aryacoind
