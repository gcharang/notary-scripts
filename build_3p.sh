#!/bin/bash

set -euxo pipefail

PWD==$(pwd)

AYA() {
    cd ~
    if [ -d AYAv2 ]; then
        cd AYAv2
        git checkout master
        cd $PWD
    else
        git clone https://github.com/sillyghost/AYAv2.git -b master --single-branch
        cd $PWD
    fi

    cp ./build/aya.sh ~/AYAv2/build.sh
    cd ~/AYAv2
    ./build.sh
}
AYA
