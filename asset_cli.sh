#!/bin/bash

args="$@"

cd ~/dPoW/iguana

./listassetchains | while read chain; do
    echo $chain
    komodo-cli --ac_name=$chain $args
done
