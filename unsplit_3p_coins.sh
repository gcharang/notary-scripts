#!/bin/bash

source config
cd ~/dPoW/iguana

# needs work
# declare -A coins

# coins[CHIPS]=$HOME/chips3/src/chips-cli
# #coins[GAME]=$HOME/GameCredits/src/gamecredits-cli
# coins[EMC2]=$HOME/einsteinium/src/einsteinium-cli
# #coins[HUSH]=$HOME/hush/src/hush-cli
# coins[VRSC]=/usr/local/bin/verus
# coins[AYA]=/usr/local/bin/aryacoin-cli

# for i in "${!coins[@]}"; do # access the keys with ${!array[@]}
#     # key - $i, value - ${coins[$i]}
#     #do_autosplit $i ${coins[$i]} 10 20
#     echo $i
#     balance=$(${coins[$i]} getbalance)
#     toSend=$(echo "$balance - 0.003" | bc | sed 's/^\./0./')
#     txid=$(${coins[$i]} sendtoaddress $kmd_address $toSend)
#     echo "merged $toSend coins in $txid"
# done
