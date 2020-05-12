#!/bin/bash

set -euxo pipefail

PWD==$(pwd)

AYA() {
	if [ ! -f ~/.aryacoin/aryacoin.conf ]; then
		cat <<-EOF >~/.aryacoin/aryacoin.conf
			server=1
			daemon=1
			txindex=1
			rpcuser=user
			rpcpassword=$(xxd -l 16 -p /dev/urandom)
			bind=127.0.0.1
			rpcbind=127.0.0.1
			rpcallowip=127.0.0.1
		EOF
	fi
	chmod 600 ~/.aryacoin/aryacoin.conf
	cd ~
	if [ -d AYAv2 ]; then
		cd AYAv2
		git checkout master
		cd $PWD
	else
		git clone https://github.com/sillyghost/AYAv2.git -b master --single-branch
		cd $PWD
	fi

	cp ./build/aya.sh ~/AYAv2/build.sh
	cd ~/AYAv2
	./build.sh
}
AYA
