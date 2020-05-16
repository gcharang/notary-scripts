#!/bin/bash

set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

source config

cp -f ~/dPoW/iguana/pubkey.txt ~/komodo/src/pubkey.txt
