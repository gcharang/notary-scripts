#!/bin/bash

#set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt

source ~/komodo/src/pubkey.txt

bitcoind &
verusd -pubkey=$pubkey &
sleep 60
#komodod -gen -genproclimit=1 -notary -pubkey=$pubkey -minrelaytxfee=0.000035 -opretmintxfee=0.004 &
komodod -notary -pubkey=$pubkey -minrelaytxfee=0.000035 -opretmintxfee=0.004 &
sleep 600
cd komodo/src
./assetchains
