#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

tmux new-window -n 'tails'
tmux split-window -v -t 0
tmux select-pane -T komodo
tail -f ~/.komodo/debug.log
tmux split-window -v -t 0 "tail -f ~/.komodo/debug.log"

tmux select-pane -T title1
