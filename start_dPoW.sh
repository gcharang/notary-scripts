#!/bin/bash

#set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e
source config

if [ "$main" = true && "$third_party" = true ]; then
    echo 'Please update config to set only one of "main" or "third_party" to be true'
elif [ "$main" = false && "$third_party" = false ]; then
    echo 'Please update config to set atleast one of "main" or "third_party" to be true'
elif [ "$main" = false && "$third_party" = true ]; then
    cd ~/dPoW/iguana
    ./m_notary_3rdparty
elif [ "$main" = true && "$third_party" = false ]; then
    cd ~/dPoW/iguana
    ./m_notary_KMD
else
    echo "Please check your config file"
fi
