#!/bin/bash

set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

source config

cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt

source ~/komodo/src/pubkey.txt

chipsd -pubkey=$pubkey &
gamecreditsd -pubkey=$pubkey &
einsteiniumd -pubkey=$pubkey &
gincoind -pubkey=$pubkey &
sleep 60
cd komodo/src
komodod -pubkey=$pubkey &
hushd &
aryacoind &
