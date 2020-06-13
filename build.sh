#!/bin/bash

set -euo pipefail
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -e

source config

if [ "$main" = true ] && [ "$third_party" = true ]; then
	echo 'Please update config to set only one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = false ]; then
	echo 'Please update config to set atleast one of "main" or "third_party" to be true'
elif [ "$main" = false ] && [ "$third_party" = true ]; then

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
			git reset --hard
			git checkout s4
			git pull
			cd iguana
		else
			git clone https://github.com/KomodoPlatform/dPoW -b s4
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
		git checkout b998ca1
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
				rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
				bind=127.0.0.1
				rpcbind=127.0.0.1
				rpcallowip=127.0.0.1
			EOF
		fi
		chmod 600 ~/.aryacoin/aryacoin.conf
		cd ~
		if [ -d AYAv2 ]; then
			cd AYAv2
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/sillyghost/AYAv2.git -b master

		fi
		git checkout fd94422
		cd $SCRIPT_DIR
		cp ./build/aya.sh ~/AYAv2/build.sh
		cd ~/AYAv2
		./build.sh
	}

	HUSH() {
		cd ~
		if [ -d hush3 ]; then
			cd hush3
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/myhush/hush3 -b master
			cd hush3
		fi
		git checkout v3.3.1
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
				rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
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
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/jl777/chips3 -b master
		fi
		git checkout 31d59f9
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
				rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
				bind=127.0.0.1
				rpcbind=127.0.0.1
				rpcallowip=127.0.0.1
			EOF
		fi
		chmod 600 ~/.gamecredits/gamecredits.conf
		cd ~
		if [ -d GameCredits ]; then
			cd GameCredits
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/gamecredits-project/GameCredits -b master
		fi
		git checkout 025f105
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
				rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
				bind=127.0.0.1
				rpcbind=127.0.0.1
				rpcallowip=127.0.0.1
			EOF
		fi
		chmod 600 ~/.einsteinium/einsteinium.conf
		cd ~
		if [ -d einsteinium ]; then
			cd einsteinium
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/emc2foundation/einsteinium -b master
		fi
		git checkout 70d7dc2
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
				rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
				bind=127.0.0.1
				rpcbind=127.0.0.1
				rpcallowip=127.0.0.1
			EOF
		fi
		chmod 600 ~/.gincoincore/gincoincore.conf
		cd ~
		if [ -d gincoin-core ]; then
			cd gincoin-core
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/GIN-coin/gincoin-core -b master
		fi
		cd $SCRIPT_DIR
		cp ./build/gincoin.sh ~/gincoin-core/build.sh
		cd ~/gincoin-core
		./build.sh
	}

	MCL() {
		cd ~
		if [ -d Marmara-v.1.0 ]; then
			cd Marmara-v.1.0
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/marmarachain/Marmara-v.1.0 -b master
			cd Marmara-v.1.0
			git checkout 9013c5cb1bc88cf5db5910e4f251f56757385f5f
		fi
		./zcutil/build.sh -j$(nproc)
		echo "Done building MCL!"
	}
	VRSC() {
		cd ~
		if [ -d VerusCoin ]; then
			cd VerusCoin
			git reset --hard
			git clean -fdx
			git checkout master
			git pull
		else
			git clone https://github.com/VerusCoin/VerusCoin -b master
			cd VerusCoin
		fi
		git checkout 9d4787b
		./zcutil/build.sh -j$(nproc)
		echo "Done building VRSC!"
		sudo ln -sf /home/$USER/VerusCoin/src/verusd /usr/local/bin/verusd
		sudo ln -sf /home/$USER/VerusCoin/src/verus /usr/local/bin/verus
	}

	SYNC() {
		verusd &
		chipsd &
		gamecreditsd &
		einsteiniumd &
		#gincoind &
		komodod &
		hushd &
		aryacoind &
		#~/Marmara-v.1.0/src/komodod -ac_name=MCL -ac_supply=2000000 -ac_cc=2 -addnode=37.148.210.158 -addnode=37.148.212.36 -addressindex=1 -spentindex=1 -ac_marmara=1 -ac_staked=75 -ac_reward=3000000000 &
	}

	if [ $# = 0 ]; then
		NANOMSG
		IGUANA
		KOMODO
		AYA
		HUSH
		CHIPS
		GAME
		EMC2
		#GIN
		#MCL
		VRSC

		SYNC
	else
		eval $1
		eval $2
	fi

elif [ "$main" = true ] && [ "$third_party" = false ]; then
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
			git checkout s4
			git pull
			cd iguana
		else
			git clone https://github.com/KomodoPlatform/dPoW -b s4
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
		git checkout b998ca1
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

	SYNC() {
		bitcoind &
		komodod &
		#echo "Waiting 6 minutes to give the daemons time to startup properly"
		#sleep 360
		cd ~/dPoW/iguana
		./assetchains.old
		echo "Waiting 10 minutes to give the daemons time to startup properly"
		sleep 600
		find ~/.komodo -type f -iname "*.conf" -exec chmod 600 {} \; # restricts access to all Smart Chain conf files
	}

	if [ $# = 0 ]; then
		NANOMSG
		IGUANA
		KOMODO
		BITCOIN

		SYNC
	else
		eval $1
		eval $2
	fi

else
	echo "Please check your config file"
fi
