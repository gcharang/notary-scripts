# Scripts for running Komodo Notary Node

These scripts work for Ubuntu 18.04/20.04 and Debian 10

## For both Main and 3P server

In a fresh server, set ulimit value

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
./init.sh
./
```
