#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

tmux new-window -n 'tails'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T KMD && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T GAME && tail -f ~/.gamecredits/debug.log'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T GIN && tail -f ~/.gincoincore/debug.log'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T CHIPS && tail -f ~/.chips/debug.log'
tmux select-pane -t 0
tmux split-window -h -t 0 'tmux select-pane -T HUSH && tail -f ~/.komodo/HUSH3/debug.log'
tmux select-pane -t 0
tmux split-window -h -t 0 'tmux select-pane -T EMC2 && tail -f ~/.einsteinium/debug.log'
tmux select-pane -t 0
tmux split-window -h -t 0 'tmux select-pane -T AYA && tail -f ~/.aryacoin/debug.log'
tmux select-pane -t 0
tmux select-layout tiled
tmux select-pane -T daemons
if [ "$1" = 1 ]; then
    ./3p_start_coins.sh
fi

#tmux select-pane -T title1

#tmux new-window \; split-window -v -l 25 \; split-window -h -l 70 \; select-pane -U \; split-window -h -l 70 \; select-pane -L
#tmux new-window \; split-window -v -l 25 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 "tail -f ~/.komodo/debug.log"\;
#tmux select-layout tiled
