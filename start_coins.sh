#!/bin/bash

#set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e
source config

if [ "$main" = true ] && [ "$third_party" = true ]; then
    echo 'Please update config to set only one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = false ]; then
    echo 'Please update config to set atleast one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = true ]; then
    cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt
    source ~/komodo/src/pubkey.txt
    chipsd -pubkey=$pubkey &
    einsteiniumd -pubkey=$pubkey &
    smartusdd -pubkey=$pubkey &
    aryacoind -pubkey=$pubkey &
    ~/VerusCoin/src/verusd -pubkey=$pubkey &
    ~/Marmara-v.1.0/src/komodod -ac_name=MCL -pubkey=$pubkey -ac_supply=2000000 -ac_cc=2 -addnode=37.148.210.158 -addnode=37.148.212.36 -addressindex=1 -spentindex=1 -ac_marmara=1 -ac_staked=75 -ac_reward=3000000000 &
    sleep 60
    cd komodo/src
    ./komodod -notary -pubkey=$pubkey &
    gleecbtcd -pubkey=$pubkey &
elif [ "$main" = true ] && [ "$third_party" = false ]; then
    cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt
    source ~/dPoW/iguana/pubkey.txt
    litecoind &
    komodod -gen -genproclimit=1 -pubkey=$pubkey -minrelaytxfee=0.000035 -opretmintxfee=0.004 -notary=".litecoin/litecoin.conf" &
    cd ~/dPoW/iguana
    cp -f assetchains.old ~/komodo/src
    cp -f assetchains.json ~/komodo/src
    cd ~/komodo/src
    ./assetchains.old
else
    echo "Please check your config file"
fi
