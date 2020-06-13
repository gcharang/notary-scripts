#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

source config

if [ "$main" = true ] && [ "$third_party" = true ]; then
    echo 'Please update config to set only one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = false ]; then
    echo 'Please update config to set atleast one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = true ]; then
    tmux new-window -n 'tails'
    tmux select-pane -t 0
    tmux split-window -v -t 0 'tmux select-pane -T KMD && tail -f ~/.komodo/debug.log'
    #tmux select-pane -t 0
    #tmux split-window -h -t 0 'tmux select-pane -T MCL && tail -f ~/.komodo/MCL/debug.log'
    tmux select-pane -t 0
    tmux split-window -v -t 0 'tmux select-pane -T GAME && tail -f ~/.gamecredits/debug.log'
    tmux select-pane -t 0
    tmux split-window -v -p 25 -t 0 'tmux select-pane -T VRSC && tail -f ~/.komodo/VRSC/debug.log'
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

elif [ "$main" = true ] && [ "$third_party" = false ]; then

    tmux new-window -n 'tails'
    # multitail for smart chains
    MILTITAIL_CMD="multitail --mergeall --no-repeat --follow-all"
    for f in $(find ~/.komodo -name 'debug.log'); do
        if [ $f != "/home/$USER/.komodo/debug.log" ] && [ $f != "/home/$USER/.komodo/VRSC/debug.log" ]; then
            COIN_NAME=$(echo "$f" | awk -F'/' '{print $5}')
            MILTITAIL_CMD="$MILTITAIL_CMD --label '[$COIN_NAME]' $f"
        fi
    done
    tmux select-pane -t 0
    tmux split-window -h -t 0 "tmux select-pane -T SMARTCHAINS && eval $MILTITAIL_CMD"

    #multitail --mergeall --no-repeat --follow-all --label "[KMD]" ~/.komodo/debug.log --label "[BTC]" ~/.bitcoin/debug.log

    tmux select-pane -t 0
    tmux split-window -v -p 40 -t 0 'tmux select-pane -T KMD && tail -f ~/.komodo/debug.log'
    tmux select-pane -t 0
    tmux split-window -v -p 70 -t 0 'tmux select-pane -T BTC && tail -f ~/.bitcoin/debug.log'
    tmux select-pane -t 0
    #tmux select-layout tiled

    if [ "$1" = 1 ]; then
        ./main_start_coins.sh
    fi

#tmux select-pane -T title1

#tmux new-window \; split-window -v -l 25 \; split-window -h -l 70 \; select-pane -U \; split-window -h -l 70 \; select-pane -L
#tmux new-window \; split-window -v -l 25 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 \; split-window -h -l 50 "tail -f ~/.komodo/debug.log"\;
#tmux select-layout tiled

else
    echo "Please check your config file"
fi
