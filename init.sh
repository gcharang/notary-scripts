#!/bin/bash

set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

git submodule init
git submodule update --init --recursive
if [ -f /etc/debian_version ]; then
    DEBIAN_VERSION=$(cat /etc/debian_version)
    DEBIAN_VERSION=${DEBIAN_VERSION%.*}
    if [ "$DEBIAN_VERSION" -eq 10 ]; then
        sudo apt install php7.3-cli php7.3-gmp php7.3-mbstring ncurses-term multitail
    fi
else
    sudo apt install php7.2-cli php7.2-gmp php7.2-mbstring multitail
fi

# Setup logrotate

sudo apt-get install logrotate
tmp=/tmp/coin-daemon-logs.eof
cat <<-EOL >$tmp
/home/*/.*/debug.log /home/*/.komodo/*/debug.log {
  daily
  rotate 3
  copytruncate
  missingok
  notifempty
  compress
}
EOL
sudo mv $tmp /etc/logrotate.d/coin-daemon-logs
