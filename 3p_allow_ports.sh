#!/bin/bash

#readarray -t 3p_coins < <(curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/s4/iguana/3p_coins.json | jq -r '[.[].newcoin] | join("\n")')
# eval "sudo ufw allow ${p2pport}/tcp comment '${coin} p2p port'"
#curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/s4/iguana/3p_coins.json | jq -r '[.[] | "sudo ufw allow \(.p2p)/tcp comment \"\(.newcoin) p2p port\""] | join("\n")'

readarray -t ufw_3p_commands < <(curl -s https://raw.githubusercontent.com/KomodoPlatform/dPoW/s4/iguana/3p_coins.json | jq -r '[.[] | "sudo ufw allow \(.p2p)/tcp comment \"\(.newcoin) p2p port\""] | join("\n")')

for ufw_command in "${ufw_3p_commands[@]}"; do
    eval $ufw_command
done
