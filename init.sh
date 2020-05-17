#!/bin/bash

set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

git submodule init
git submodule update --init --recursive
sudo apt install php7.2-cli php7.2-gmp php7.2-mbstring
