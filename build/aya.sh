#!/bin/bash
# AYA build script for Ubuntu & Debian (c) Decker (and webworker)

set -euxo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

berkeleydb() {
    AYA_ROOT=$(pwd)
    AYA_PREFIX="${AYA_ROOT}/db4"
    mkdir -p $AYA_PREFIX
    wget -N 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
    echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef db-4.8.30.NC.tar.gz' | sha256sum -c
    tar -xzvf db-4.8.30.NC.tar.gz
    cat <<-EOL >atomic-builtin-test.cpp
        #include <stdint.h>
        #include "atomic.h"

        int main() {
        db_atomic_t *p; atomic_value_t oldval; atomic_value_t newval;
        __atomic_compare_exchange(p, oldval, newval);
        return 0;
        }
EOL
    if g++ atomic-builtin-test.cpp -I./db-4.8.30.NC/dbinc -DHAVE_ATOMIC_SUPPORT -DHAVE_ATOMIC_X86_GCC_ASSEMBLY -o atomic-builtin-test 2>/dev/null; then
        echo "No changes to bdb source are needed ..."
        rm atomic-builtin-test 2>/dev/null
    else
        echo "Updating atomic.h file ..."
        sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' db-4.8.30.NC/dbinc/atomic.h
    fi
    cd db-4.8.30.NC/build_unix/
    ../dist/configure -enable-cxx -disable-shared -with-pic -prefix=$AYA_PREFIX
    make install
    cd $AYA_ROOT
}
buildAYA() {
    if [ -f ./src/aryacoind ]; then
        make clean
    fi
    ./autogen.sh
    ./configure LDFLAGS="-L${AYA_PREFIX}/lib/" CPPFLAGS="-I${AYA_PREFIX}/include/" --with-gui=no --disable-tests --disable-bench --without-miniupnpc --enable-experimental-asm --enable-static --disable-shared --with-incompatible-bdb
    make -j$(nproc)
}
berkeleydb
buildAYA
echo "Done building AYA!"
sudo ln -sf /home/$USER/AYAv2/src/aryacoin-cli /usr/local/bin/aryacoin-cli
sudo ln -sf /home/$USER/AYAv2/src/aryacoind /usr/local/bin/aryacoind
