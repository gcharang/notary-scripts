# Scripts for running Komodo Notary Node

Use https://github.com/DeckerSU/address_gen to generate seed words for vanity KMD addresses.

```git
diff --git a/vanity.cpp b/vanity.cpp
index 69e879e..e5a35b9 100644
--- a/vanity.cpp
+++ b/vanity.cpp
@@ -130,7 +130,7 @@ int main()
     std::string start_pattern = "beginofyourpassphrase";
     std::string end_pattern = "endofyourpassphrase";
     
-    check_passphrase(start_pattern, end_pattern, "komod");
+    check_passphrase(start_pattern, end_pattern, "gcg");
 
     return 0; 
-}
```

Notary script repos for reference:
- https://github.com/gcharang/nntools
- https://github.com/MrMLynch/nnutils

The scripts in this repo work for Debian 10

## For both Main and 3P server

### Update tmux and install dependencies

```bash
./init.sh # installs deps
./tmux_install_latest.sh
```

Kill the current tmux session and relaunch a new one if necessary.

### Set ulimit value

In a fresh server:

### Edit the `/etc/security/limits.conf` file

```bash
sudo nano /etc/security/limits.conf
```

add these lines:

```bash
* soft nofile 1000000
* hard nofile 1000000
```

Save and close the file

### Edit the `/etc/pam.d/common-session` file

```bash
sudo nano /etc/pam.d/common-session
```

add this line:

```bash
session required pam_limits.so
```

Save and close the file, then reboot the server.
After reboot, confirm that the `ulimit` value is updated to `1000000`

```bash
ulimit -n
```

### Config

- `cp config_sample config`
- change the values of `pubkey` and `passphrase` appropriately (Main server vs 3P) in the newly created `config` file

## 3rd Party Server

```bash
./3p_build.sh
php importWifs3pCoins # in a different window/pane and execute the commands displayed to import the wifs. wait 10 minutes and execute the next commands
./3p_stop_coins.sh # wait a minute
./3p_tails_tmux.sh # starts a new window with all the tails and starts all the daemons
./3p_start_iguana.sh # after chains are synced and rescans done
./3p_start_dPoW.sh # after seeing "INIT with 64 notaries"
```