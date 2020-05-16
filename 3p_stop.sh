#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

pkill -15 iguana
komodo-cli stop
hush-cli stop
chips-cli stop
gamecredits-cli stop
einsteinium-cli stop
gincoin-cli stop
aryacoin-cli stop
