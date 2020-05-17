#!/bin/bash
# GAME build script for Ubuntu & Debian 9 v.3 (c) Decker (and webworker)
# Modified for Debian 10 by gcharang

set -euxo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

berkeleydb() {
    GAMECREDITS_ROOT=$(pwd)
    GAMECREDITS_PREFIX="${GAMECREDITS_ROOT}/db4"
    mkdir -p $GAMECREDITS_PREFIX
    wget -N 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef db-4.8.30.NC.tar.gz' | sha256sum -c
    tar -xzvf db-4.8.30.NC.tar.gz
    if [ -f /etc/debian_version ]; then
        DEBIAN_VERSION=$(cat /etc/debian_version)
        DEBIAN_VERSION_10=${DEBIAN_VERSION%.*}
        if [ "$DEBIAN_VERSION_10" = "10" ] || [ "$DEBIAN_VERSION" = "bullseye/sid" ]; then
            #https://www.fsanmartin.co/compiling-berkeley-db-4-8-30-in-ubuntu-19/
            sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-4.8.30.NC/dbinc/atomic.h
        fi
    fi
    cd db-4.8.30.NC/build_unix/
    ../dist/configure -enable-cxx -disable-shared -with-pic -prefix=$GAMECREDITS_PREFIX
    make install
    cd $GAMECREDITS_ROOT
}
OpenSSL() {
    version=1.0.2o
    mkdir -p openssl_build
    wget -qO- http://www.openssl.org/source/openssl-$version.tar.gz | tar xzv
    cd openssl-$version
    export CFLAGS=-fPIC
    ./config no-shared --prefix=$GAMECREDITS_ROOT/openssl_build
    make -j$(nproc)
    make install
    cd ..

    export PKG_CONFIG_PATH="$GAMECREDITS_ROOT/openssl_build/pkgconfig"
    export CXXFLAGS+=" -I$GAMECREDITS_ROOT/openssl_build/include/ -I${GAMECREDITS_PREFIX}/include/"
    export LDFLAGS+=" -L$GAMECREDITS_ROOT/openssl_build/lib -L${GAMECREDITS_PREFIX}/lib/ -static"
    export LIBS+="-ldl"

    # p.s. for Debian added -ldl in LDFLAGS it's enough, but on Ubuntu linker doesn't recognize it, so,
    # we moved -ldl to LIBS and added -static to LDFLAGS, because linker on Ubuntu doesn't understan that
    # it should link librypto.a statically.
    #
    # Or we can build OpenSSL 1.0.x as shared (instead of no-shared) and use:
    # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/$USER/GameCredits/openssl_build/lib before
    # starting gamecreditsd.
}
buildGAME() {
    if [ -f ./src/gamecreditsd ]; then
        make clean
    fi
    git pull
    ./autogen.sh
    ./configure --with-gui=no --disable-tests --disable-bench --without-miniupnpc --enable-experimental-asm --enable-static --disable-shared
    make -j$(nproc)
}
berkeleydb
OpenSSL
buildGAME
echo "Done building GAME!"
sudo ln -sf /home/$USER/GameCredits/src/gamecredits-cli /usr/local/bin/gamecredits-cli
sudo ln -sf /home/$USER/GameCredits/src/gamecreditsd /usr/local/bin/gamecreditsd
