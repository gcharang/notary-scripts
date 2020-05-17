#!/bin/bash

set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

# KMD
tail -f ~/.komodo/debug.log
# HUSH
tail -f ~/.komodo/HUSH3/debug.log
# CHIPS
tail -f ~/.chips/debug.log
# GAME
tail -f ~/.gamecredits/debug.log
# EMC2
tail -f ~/.einsteinium/debug.log
# GIN
tail -f ~/.gincoincore/debug.log
# AYA
tail -f ~/.aryacoin/debug.log
