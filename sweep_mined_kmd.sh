#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

#!/bin/bash
cd ~/notary-scripts
source config
coin="KMD"
address=$kmd_cold_address
cli="komodo-cli"
txfee="0.0002"
date=$(date +%Y-%m-%d:%H:%M:%S)
iguana_age_threshold="999999"

echo "[${coin}] Checking mining UTXOs - ${date}"

mining_rewards=$(${cli} listunspent | jq -r 'map(select(.spendable == true and .amount > 3))')
no_of_mining_utxos=$(echo $mining_rewards | jq -r 'length')
total_mining_rewards=$(echo $mining_rewards | jq -r '.[].amount' | paste -sd+ - | bc)

echo "[${coin}] ${no_of_mining_utxos} mining UTXOs totalling ${total_mining_rewards} ${coin}"

no_of_utxos=$no_of_mining_utxos
amount_of_utxos=$total_mining_rewards

if [[ $no_of_utxos -gt 0 ]]; then
    output_amount=$(echo "$amount_of_utxos-$txfee" | bc | sed 's/^\./0./')

    # Add a 0 if output amount starts with a decimal place
    #if [[ "${output_amount:0:1}" = "." ]]; then
    #    output_amount="0${output_amount}"
    #fi

    transaction_inputs=$(jq -r --argjson mining_rewards "$mining_rewards" -n '$mining_rewards | [.[] | {txid, vout}]')
    transaction_outputs="{\"$address\":$output_amount}"

    echo "[${coin}] Consolidating down ${output_amount} ${coin} to ${address}"

    raw_tx=$(${cli} createrawtransaction "$transaction_inputs" "$transaction_outputs")

    echo $raw_tx

    signed_raw_tx=$(${cli} signrawtransaction "${raw_tx}" | jq -r '.hex')
    #txid=$(${cli} sendrawtransaction "$signed_raw_tx")

    echo "${cli} sendrawtransaction $signed_raw_tx"

#  echo "[${coin}] TXID: ${txid}"
fi

#now=$(date '+%d/%m/%Y %H:%M:%S')
#balance=$(komodo-cli -ac_name=LABS getbalance)
#balance=$(echo "$balance/1" | bc)
#if [ $balance -gt 5 ]; then
#  toSend=$((balance-5))
#  if [ $toSend -gt 0 ]; then
#    txid=$(komodo-cli -ac_name=LABS sendtoaddress RUrhMv8Cdz3cnHj6smbGWJfCTQpcamLFUk $toSend)
#    echo "sent_notary_rewards $now $toSend  $txid"
#    /home/gcharang/LabsNotary/utxosplitter.sh >> /home/gcharang/utxo_split.log 2>&1
#  fi
#else
#  echo "balance_insufficient $now"
#fi
