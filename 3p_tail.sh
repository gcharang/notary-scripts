#!/bin/bash

set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

# KMD
tail ~/.komodo/debug.log
# HUSH
tail ~/.komodo/HUSH3/debug.log
# CHIPS
tail ~/.chips/debug.log
# GAME
tail ~/.gamecredits/debug.log
# EMC2
tail ~/.einsteinium/debug.log
# GIN
tail ~/.gincoincore/debug.log
# AYA
tail ~/.aryacoin/debug.log
