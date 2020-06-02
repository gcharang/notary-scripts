#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

time (~/komodo/src/komodo-cli listunspent | jq '. | { "utxos" : length }' && ~/komodo/src/komodo-cli getwalletinfo | jq '{ "txcount" : .txcount }') | jq -s '.[0] * . [1]'
