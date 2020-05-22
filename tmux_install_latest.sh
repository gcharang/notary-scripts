#!/bin/bash

#set -exuo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

sudo apt-get libevent-dev ncurses-dev build-essential bison pkg-config libncurses-dev
rm -fr /tmp/tmux
mkdir -p /tmp/tmux
cd /tmp/tmux
wget -qO- https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz | tar xzv
cd tmux-3.1b
./configure
make && sudo make install
rm -fr /tmp/tmux
sudo killall -9 tmux