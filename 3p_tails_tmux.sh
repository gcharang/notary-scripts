#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

tmux new-window -n 'tails'
tmux split-window -v -t 0 'tmux select-pane -T AYA && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T GAME && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T GIN && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -v -t 0 'tmux select-pane -T CHIPS && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -h -t 0 'tmux select-pane -T HUSH && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -h -t 0 'tmux select-pane -T VRSC && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux split-window -h -t 0 'tmux select-pane -T KMD && tail -f ~/.komodo/debug.log'
tmux select-pane -t 0
tmux select-layout tiled
#tmux select-pane -T title1

#tmux new-window \; split-window -v -l 25 \; split-window -h -l 70 \; select-pane -U \; split-window -h -l 70 \; select-pane -L
#tmux new-window \; split-window -v -l 25 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 "tail -f ~/.komodo/debug.log"\;
#tmux select-layout tiled
