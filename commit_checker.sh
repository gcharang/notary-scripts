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
    source ~/dPoW/iguana/pubkey.txt
    chipsd -pubkey=$pubkey &
    #gamecreditsd -pubkey=$pubkey &
    einsteiniumd -pubkey=$pubkey &
    #hushd -pubkey=$pubkey &
    aryacoind -pubkey=$pubkey &
    verusd -pubkey=$pubkey &
    #~/Marmara-v.1.0/src/komodod -ac_name=MCL -pubkey=$pubkey -ac_supply=2000000 -ac_cc=2 -addnode=37.148.210.158 -addnode=37.148.212.36 -addressindex=1 -spentindex=1 -ac_marmara=1 -ac_staked=75 -ac_reward=3000000000 &
    komodod -notary -pubkey=$pubkey &
elif [ "$main" = true ] && [ "$third_party" = false ]; then
    cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt
    source ~/dPoW/iguana/pubkey.txt
    bitcoind &
    komodod -gen -genproclimit=1 -notary -pubkey=$pubkey -minrelaytxfee=0.000035 -opretmintxfee=0.004 &
    #komodod -notary -pubkey=$pubkey -minrelaytxfee=0.000035 -opretmintxfee=0.004 &
    cd ~/dPoW/iguana
    cp -f assetchains.old ~/komodo/src
    cp -f assetchains.json ~/komodo/src
    cd ~/komodo/src
    ./assetchains.old
else
    echo "Please check your config file"
fi
