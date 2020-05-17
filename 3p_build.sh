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

KOMODO() {
	mkdir -p ~/.komodo
	if [ ! -f ~/.komodo/komodo.conf ]; then
		cat <<-EOF >~/.komodo/komodo.conf
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

AYA() {
	mkdir -p ~/.aryacoin
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
	else
		git clone https://github.com/sillyghost/AYAv2.git -b master

	fi
	cd $SCRIPT_DIR
	cp ./build/aya.sh ~/AYAv2/build.sh
	cd ~/AYAv2
	./build.sh
}

HUSH() {
	cd ~
	if [ -d hush3 ]; then
		cd hush3
		if [ -f ./src/hushd ]; then
			make clean
		fi
		git checkout v3.3.1
		git pull
	else
		git clone https://github.com/myhush/hush3 -b v3.3.1
		cd hush3
	fi
	./zcutil/build.sh -j$(nproc)
	echo "Done building HUSH!"
	sudo ln -sf /home/$USER/hush3/src/hush-cli /usr/local/bin/hush-cli
	sudo ln -sf /home/$USER/hush3/src/hushd /usr/local/bin/hushd
}

CHIPS() {
	mkdir -p ~/.chips
	if [ ! -f ~/.chips/chips.conf ]; then
		cat <<-EOF >~/.chips/chips.conf
			server=1
			daemon=1
			txindex=1
			rpcuser=user
			rpcpassword=$(xxd -l 16 -p /dev/urandom)
			addnode=159.69.23.29
			addnode=95.179.192.102
			addnode=149.56.29.163
			addnode=145.239.149.173
			addnode=178.63.53.110
			addnode=151.80.108.76
			addnode=185.137.233.199
			rpcbind=127.0.0.1
			rpcallowip=127.0.0.1
		EOF
	fi
	chmod 600 ~/.chips/chips.conf
	cd ~
	if [ -d chips3 ]; then
		cd chips3
		git checkout dev
	else
		git clone https://github.com/jl777/chips3 -b dev
	fi
	cd $SCRIPT_DIR
	cp ./build/chips.sh ~/chips3/build_chips.sh
	cd ~/chips3
	./build_chips.sh
}

GAME() {
	mkdir -p ~/.gamecredits
	if [ ! -f ~/.gamecredits/gamecredits.conf ]; then
		cat <<-EOF >~/.gamecredits/gamecredits.conf
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
	chmod 600 ~/.gamecredits/gamecredits.conf
	cd ~
	if [ -d GameCredits ]; then
		cd GameCredits
		git checkout master
	else
		git clone https://github.com/gamecredits-project/GameCredits -b master
	fi
	cd $SCRIPT_DIR
	cp ./build/gamecredits.sh ~/GameCredits/build.sh
	cd ~/GameCredits
	./build.sh
}

EMC2() {
	mkdir -p ~/.einsteinium
	if [ ! -f ~/.einsteinium/einsteinium.conf ]; then
		cat <<-EOF >~/.einsteinium/einsteinium.conf
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
	chmod 600 ~/.einsteinium/einsteinium.conf
	cd ~
	if [ -d einsteinium ]; then
		cd einsteinium
		git checkout master
	else
		git clone https://github.com/emc2foundation/einsteinium -b master
	fi
	cd $SCRIPT_DIR
	cp ./build/einsteinium.sh ~/einsteinium/build.sh
	cd ~/einsteinium
	./build.sh
}

GIN() {
	mkdir -p ~/.gincoincore
	if [ ! -f ~/.gincoincore/gincoincore.conf ]; then
		cat <<-EOF >~/.gincoincore/gincoincore.conf
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
	chmod 600 ~/.gincoincore/gincoincore.conf
	cd ~
	if [ -d gincoin-core ]; then
		cd gincoin-core
		git checkout master
	else
		git clone https://github.com/GIN-coin/gincoin-core -b master
	fi
	cd $SCRIPT_DIR
	cp ./build/gincoin.sh ~/gincoin-core/build.sh
	cd ~/gincoin-core
	./build.sh
}

NANOMSG
IGUANA
KOMODO
AYA
HUSH
CHIPS
GAME
EMC2
GIN
