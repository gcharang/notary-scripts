#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/

echo "this script kills your current tmux session if any. you have to kill the tmux server and restart it"
echo "this is your chance to CTRL+C it"
echo "waiting 5 seconds"
echo "in 5..." && sleep 1
echo "in 4..." && sleep 1
echo "in 3..." && sleep 1
echo "in 2..." && sleep 1
echo "in 1..." && sleep 1
set -euxo pipefail
SCRIPT_DIR=$(pwd)
sudo apt-get install libevent-dev build-essential bison pkg-config libncurses5-dev libncursesw5-dev
rm -fr /tmp/tmux
mkdir -p /tmp/tmux
cd /tmp/tmux
wget -qO- https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz | tar xzv
cd tmux-3.1b
./configure
make && sudo make install
cp $SCRIPT_DIR/dotfiles/.tmux.conf ~/.tmux.conf
rm -fr /tmp/tmux
tmux kill-sess
