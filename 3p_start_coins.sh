#!/bin/bash

#set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt

source ~/komodo/src/pubkey.txt

chipsd -pubkey=$pubkey &
gamecreditsd -pubkey=$pubkey &
einsteiniumd -pubkey=$pubkey &
gincoind -pubkey=$pubkey &
hushd -pubkey=$pubkey &
aryacoind -pubkey=$pubkey &
sleep 60
~/Marmara-v.1.0/src/komodod -ac_name=MCL -pubkey=$pubkey -ac_supply=2000000 -ac_cc=2 -addnode=37.148.210.158 -addnode=37.148.212.36 -addressindex=1 -spentindex=1 -ac_marmara=1 -ac_staked=75 -ac_reward=3000000000 &
komodod -notary -pubkey=$pubkey &
