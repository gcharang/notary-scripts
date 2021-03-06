#!/bin/bash
# Usage Guide: https://techloverhd.com/2020/07/how-to-send-komodo-or-any-smart-chain-funds-from-your-address-without-rescanning-the-wallet/
# (c) Decker

source config
FROM_ADDRESS=$kmd_address
curl -s https://kmdexplorer.io/insight-api-komodo/addr/$FROM_ADDRESS/utxo >all.utxos
utxos=$(<all.utxos)
#utxo=$(echo "$utxos" | jq -c "[.[] | select (.confirmations > 100 and .amount != 0.0001 and .amount != 0.00000055) | { txid: .txid, vout: .vout}]")
#amount=$(echo "$utxos" | jq -r "[.[] | select (.confirmations > 100 and .amount != 0.0001 and .amount != 0.00000055) | .amount] | add")
utxo=$(echo "$utxos" | jq -c "[.[] | select ( .amount != 0.00000055) | { txid: .txid, vout: .vout}]")
amount=$(echo "$utxos" | jq -r "[.[] | select ( .amount != 0.00000055) | .amount] | add")

# echo $amount
# https://stackoverflow.com/questions/46117049/how-i-can-round-digit-on-the-last-column-to-2-decimal-after-a-dot-using-jq
value=$(echo $amount | jq 'def round: tostring | (split(".") + ["0"])[:2] | [.[0], "\(.[1])"[:8]] | join(".") | tonumber; . | round')
# echo $value
raw_txn=$(komodo-cli createrawtransaction '$utxo' '{\"$kmd_address\": $value}')
signed_txn=$(komodo-cli signrawtransaction $raw_txn)
touch send_signed_txn
chmod +x send_signed_txn
echo "komodo-cli sendrawtransaction $signed_txn" >>send_signed_txn
