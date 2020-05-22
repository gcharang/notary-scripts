#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

tmux set -g set-titles on
tmux setw -g window-status-current-style bg=colour0,fg=colour11,dim
tmux set -g pane-border-status top
tmux set-window-option -g window-status-current-bg blue
tmux new-window -n 'tails'
tmux split-window -v -t 0
tmux select-pane -T komodo
tail -f ~/.komodo/debug.log
tmux split-window -v -t 0 "tail -f ~/.komodo/debug.log"

tmux select-pane -T title1
