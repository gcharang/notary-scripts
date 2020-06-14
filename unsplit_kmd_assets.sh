#!/bin/bash

source config
cd ~/dPoW/iguana
echo "KMD"
balance=$(komodo-cli getbalance)
toSend=$(echo "$balance - 0.003" | bc)
txid=$(komodo-cli sendtoaddress $kmd_address 0${toSend})
echo "merged $toSend coins in $txid"
./listassetchains | while read chain; do
    echo $chain
    balance=$(komodo-cli -ac_name=$chain getbalance)
    toSend=$(echo "$balance - 0.004" | bc)
    txid=$(komodo-cli -ac_name=$chain sendtoaddress $kmd_address $toSend)
    echo "merged $toSend coins in $txid"
done
