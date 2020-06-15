#!/bin/bash
#set -exuo pipefail
source ~/notary-scripts/config
nAddress=$kmd_address
NN_PUBKEY="21${pubkey}ac"
date=$(date +'%Y-%m-%d %H:%M:%S')

source $HOME/.profile
# CONFIG
komodo_cli=/usr/local/bin/komodo-cli
iguana_port=7776

function init_colors() {
	RESET="\033[0m"
	BLACK="\033[30m"
	RED="\033[31m"
	GREEN="\033[32m"
	YELLOW="\033[33m"
	BLUE="\033[34m"
	MAGENTA="\033[35m"
	CYAN="\033[36m"
	WHITE="\033[37m"
	BRIGHT="\033[1m"
	DARKGREY="\033[90m"
}
function log_print() {
	datetime=$(date '+%Y-%m-%d %H:%M:%S')
	echo -e [$datetime] $1
}
function dosplit() {
	coin=$1
	asset=$2
	utxo_min=$3
	utxo_max=$4
	utxo=$($komodo_cli $asset listunspent | jq "[.[] | select (.generated==false and .amount==0.0001 and .spendable==true and (.scriptPubKey == \"$NN_PUBKEY\"))] | length")
	if [ -n "$utxo" ] && [ "$utxo" -eq "$utxo" ] 2>/dev/null; then
		if [[ $utxo -lt $utxo_min ]]; then
			need=$(($utxo_max - $utxo))
			log_print "${BRIGHT}\x5b${RESET}${YELLOW}${coin}${RESET}${BRIGHT}\x5d${RESET} have.${utxo} --> add.${need} --> total.${utxo_max}"
			log_print "${DARKGREY}curl -s --url \"http://127.0.0.1:$iguana_port\" --data '{\"coin\":\"${coin}\",\"agent\":\"iguana\",\"method\":\"splitfunds\",\"satoshis\":\"10000\",\"sendflag\":1,\"duplicates\":\"${need}\"}'${RESET}"
			splitres=$(curl -s --url "http://127.0.0.1:$iguana_port" --data "{\"coin\":\""${coin}"\",\"agent\":\"iguana\",\"method\":\"splitfunds\",\"satoshis\":\"10000\",\"sendflag\":1,\"duplicates\":"${need}"}")
			error=$(echo $splitres | jq -r .error)
			txid=$(echo $splitres | jq -r .txid)
			signed=$(echo $splitres | jq -r .result)
			if [ -z "$error" ] || [ "$error" = "null" ] && [ ! -z "$splitres" ]; then
				if [ ! -z "$txid" ] && [ "$txid" != "null" ]; then
					txidcheck=$($komodo_cli $asset getrawtransaction $txid 1 2>/dev/null | jq -r .txid)
					if [ "$txidcheck" = "$txid" ]; then
						log_print "txid.${GREEN}$txid${RESET} - OK"
					else
						log_print "txid.${RED}$txid${RESET} - FAIL"
						daemonsigned=$($komodo_cli $asset signrawtransaction $signed | jq -r .hex)
						newtxid=$($komodo_cli $asset sendrawtransaction $daemonsigned)
						log_print "newtxid.$newtxid - BROADCASTED"

					fi
				else
					log_print "${RED}Iguana doesn't return txid ...${RESET}"
				fi
			else
				if [ ! -z "$splitres" ]; then
					log_print "${RED}$error${RESET}"
				else
					log_print "${RED}Failed to receive curl answer, possible iguana died ...${RESET}"
				fi
			fi
		else
			log_print "${BRIGHT}\x5b${RESET}${YELLOW}${coin}${RESET}${BRIGHT}\x5d${RESET} have.${utxo} --> don't need split ..."
		fi
	else
		log_print "${BRIGHT}\x5b${RESET}${YELLOW}${coin}${RESET}${BRIGHT}\x5d${RESET} ${RED}Error: utxo count is not a number, may be daemon dead ... ${RESET}"
	fi
}

function cleanwallettransactions() {
	coin=$1
	asset=$2
	result=$($komodo_cli $asset cleanwallettransactions)
	result_formatted=$(echo $result | jq -r '"Total Tx: \(.total_transactons) | Remaining Tx: \(.remaining_transactons) | Removed Tx: \(.removed_transactions)"')

	echo "[$coin] ${date} | $result_formatted"
}

init_colors
log_print "Starting Split ..."

#for i in "${kmd_coins[@]}"; do
#	dosplit $i
#done
cd ~/dPoW/iguana
dosplit "KMD" "" 60 80
cleanwallettransactions "KMD" ""
./listassetchains | while read chain; do
	dosplit $chain "-ac_name=${chain}" 10 20
	cleanwallettransactions $chain "-ac_name=${chain}"
done
