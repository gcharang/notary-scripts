#!/bin/bash

#readarray -t 3p_coins < <(curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/s4/iguana/3p_coins.json | jq -r '[.[].newcoin] | join("\n")')
# eval "sudo ufw allow ${p2pport}/tcp comment '${coin} p2p port'"
#curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/s4/iguana/3p_coins.json | jq -r '[.[] | "sudo ufw allow \(.p2p)/tcp comment \"\(.newcoin) p2p port\""] | join("\n")'

source config

if [ "$main" = true ] && [ "$third_party" = true ]; then
    echo 'Please update config to set only one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = false ]; then
    echo 'Please update config to set atleast one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = true ]; then
    readarray -t ufw_3p_commands < <(curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/s4/iguana/3p_coins.json | jq -r '[.[] | "sudo ufw allow \(.p2p)/tcp comment \"\(.newcoin) p2p port\""] | join("\n")')

    for ufw_command in "${ufw_3p_commands[@]}"; do
        eval $ufw_command
    done
elif [ "$main" = true ] && [ "$third_party" = false ]; then
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
else
    echo "Please check your config file"
fi
