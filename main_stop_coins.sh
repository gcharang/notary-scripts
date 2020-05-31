#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

komodo-cli stop
bitcoin-cli stop
komodo-cli -ac_name=VRSC stop
cd ~/komodo/src
./fiat-cli stop
