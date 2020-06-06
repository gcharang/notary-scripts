#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e
source config

if [ "$main" = true && "$third_party" = true ]; then
    echo 'Please update config to set only one of "main" or "third_party" to be true'
elif [ "$main" = false && "$third_party" = false ]; then
    echo 'Please update config to set atleast one of "main" or "third_party" to be true'
elif [ "$main" = false && "$third_party" = true ]; then
    komodo-cli stop
    hush-cli stop
    chips-cli stop
    gamecredits-cli stop
    einsteinium-cli stop
    gincoin-cli stop
    aryacoin-cli stop
elif [ "$main" = true && "$third_party" = false ]; then
    komodo-cli stop
    bitcoin-cli stop
    komodo-cli -ac_name=VRSC stop
    cd ~/komodo/src
    ./fiat-cli stop
else
    echo "Please check your config file"
fi
