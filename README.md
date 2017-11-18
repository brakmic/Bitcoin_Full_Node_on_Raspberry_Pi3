# Bitcoin Full Node on Raspberry Pi 3

Shell scripts and config files from [my article](https://blog.brakmic.com/running-a-full-bitcoin-node-on-raspberry-pi-3/)

## Firewall configuration

To create a proper firewall use *iptables.sh* script and put it somewhere under */usr/local*, for example */usr/local/bin*. Don't forget to make it executable with `chmod +x iptables.sh`

* Install *iptables-persistent* with `apt-get install iptables-persistent`

* Create a config dir for future iptables fiter rules: `sudo mkdir /etc/iptables`

* Execute the firewall script: `sudo /usr/local/bin/iptables.sh` and press ENTER when done.

* Check if the firewall rules have been instantiated correctly: `sudo iptables -L`



