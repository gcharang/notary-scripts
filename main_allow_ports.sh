#!/bin/bash

readarray -t kmd_coins < <(curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/dev/iguana/assetchains.json | jq -r '[.[].ac_name] | join("\n")')
kmd_coins+=(KMD)
for coin in "${kmd_coins[@]}"; do
    if [ "${coin}" != "KMD" ]; then
        p2pport=$(komodo-cli -ac_name=${coin} getinfo 2>/dev/null | jq .p2pport)
        if [ ! -z "${p2pport}" ]; then
            eval "sudo ufw allow ${p2pport}/tcp comment '${coin} p2p port'"
        fi
    else
        eval "sudo ufw allow 7770/tcp comment '${coin} p2p port'"
    fi
done
