#!/bin/bash

set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

source config

SCRIPT_DIR=$(pwd)

sudo apt-get install libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev python-zmq zlib1g-dev wget curl bsdmainutils automake cmake clang libsodium-dev libcurl4-gnutls-dev libssl-dev git unzip python jq htop -y

NANOMSG() {
	cd ~
	if [ -d nanomsg ]; then
		cd nanomsg
		git pull
	else
		git clone https://github.com/nanomsg/nanomsg
		cd nanomsg
	fi
	cmake . -DNN_TESTS=OFF -DNN_ENABLE_DOC=OFF
	make -j2
	sudo make install
	sudo ldconfig
}

IGUANA() {
	cd ~
	if [ -d dPoW ]; then
		cd dPoW
		git checkout master
		git pull
		cd iguana
	else
		git clone https://github.com/KomodoPlatform/dPoW -b master
		cd dPoW/iguana
	fi

	cat <<-EOF >pubkey.txt
		pubkey=$pubkey
	EOF

	cat <<-EOF >wp_7779
		curl --url "http://127.0.0.1:7779" --data "{\"method\":\"walletpassphrase\",\"params\":[\"$passphrase\", 9999999]}"
	EOF
	chmod 700 wp_7779
	./m_notary_build
}

# $(xxd -l 16 -p /dev/urandom)

KOMODO() {
	mkdir -p ~/.komodo
	if [ ! -f ~/.komodo/komodo.conf ]; then
		cat <<-EOF >~/.komodo/komodo.conf
			server=1
			daemon=1
			txindex=1
			rpcuser=user
			rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
			bind=127.0.0.1
			rpcbind=127.0.0.1
			rpcallowip=127.0.0.1
		EOF
	fi
	chmod 600 ~/.komodo/komodo.conf
	cd ~
	if [ -d komodo ]; then
		cd komodo
		if [ -f ./src/komodod ]; then
			make clean
		fi
		git checkout master
		git pull
	else
		git clone https://github.com/KomodoPlatform/komodo -b master
		cd komodo
	fi
	./zcutil/fetch-params.sh
	./zcutil/build.sh -j$(nproc)
	echo "Done building KOMODO!"
	sudo ln -sf /home/$USER/komodo/src/komodo-cli /usr/local/bin/komodo-cli
	sudo ln -sf /home/$USER/komodo/src/komodod /usr/local/bin/komodod
}

BITCOIN() {
	mkdir -p ~/.bitcoin
	if [ ! -f ~/.bitcoin/bitcoin.conf ]; then
		cat <<-EOF >~/.bitcoin/bitcoin.conf
			server=1
			daemon=1
			txindex=1
			rpcuser=user
			rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
			bind=127.0.0.1
			rpcbind=127.0.0.1
			rpcallowip=127.0.0.1
		EOF
	fi
	chmod 600 ~/.bitcoin/bitcoin.conf
	cd ~
	if [ -d bitcoin ]; then
		cd bitcoin
		git checkout 0.16
	else
		git clone https://github.com/bitcoin/bitcoin -b 0.16

	fi
	cd $SCRIPT_DIR
	cp ./build/bitcoin.sh ~/bitcoin/build.sh
	cd ~/bitcoin
	./build.sh
}

VRSC() {
	cd ~
	if [ -d VerusCoin ]; then
		cd VerusCoin
		if [ -f ./src/verusd ]; then
			make clean
		fi
		git checkout master
		git pull
	else
		git clone https://github.com/VerusCoin/VerusCoin -b master
		cd VerusCoin
		git checkout 391c403
	fi
	./zcutil/build.sh -j$(nproc)
	echo "Done building VRSC!"
	sudo ln -sf /home/$USER/VerusCoin/src/verusd /usr/local/bin/verusd
	sudo ln -sf /home/$USER/VerusCoin/src/verus /usr/local/bin/verus
}

SYNC() {
	bitcoind &
	komodod &
	verusd &
	echo "Waiting 6 minutes to give the daemons time to startup properly"
	sleep 360
	cd ~/komodo/src
	./assetchains.old
	echo "Waiting 10 minutes to give the daemons time to startup properly"
	sleep 600
	find ~/.komodo -type f -iname "*.conf" -exec chmod 600 {} \; # restricts access to all Smart Chain conf files
}

NANOMSG
IGUANA
KOMODO
BITCOIN
VRSC

SYNC
