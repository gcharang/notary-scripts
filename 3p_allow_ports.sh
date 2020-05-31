#!/bin/bash

kmd_coins+=(KMD)
for coin in "${kmd_coins[@]}"; do
    if [ "${coin}" != "KMD" ]; then
        p2pport=$(komodo-cli -ac_name=${coin} getinfo 2>/dev/null | jq .p2pport)
        if [ ! -z "${p2pport}" ]; then
            echo "sudo ufw allow ${p2pport}/tcp comment '${coin} p2p port'"
        fi
    else
        echo "sudo ufw allow 7770/tcp comment '${coin} p2p port'"
    fi
done
