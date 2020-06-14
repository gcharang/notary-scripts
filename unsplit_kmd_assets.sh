#!/bin/bash

source config
cd ~/dPoW/iguana
echo "KMD"
balance=$(komodo-cli getbalance)
balance=$(echo "$balance/1" | bc)
toSend=$(echo "$balance - 0.0001" | bc)
txid=$(komodo-cli sendtoaddress $kmd_address $toSend)
echo "merged $toSend coins in $txid"
./listassetchains | while read chain; do
    echo $chain
    balance=$(komodo-cli -ac_name=$chain getbalance)
    balance=$(echo "$balance/1" | bc)
    toSend=$((balance - 0.0001))
    txid=$(komodo-cli -ac_name=$chain sendtoaddress $kmd_address $toSend)
    echo "merged $toSend coins in $txid"
done
