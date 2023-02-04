#!/bin/bash
FILE="/etc/wpa_supplicant.conf"

#
#writing supplicant file
#
echo "#PSK/TKIP" > $FILE
echo "" >> $FILE
echo "ctrl_interface=/var/run/wpa_supplicant" >> $FILE
EXTRA='\n\tscan_ssid=1\n\tkey_mgmt=WPA-EAP WPA-PSK IEEE8021X NONE\n\tpairwise=TKIP CCMP\n\tgroup=CCMP TKIP WEP104 WEP40'
wpa_passphrase "$1" "$2" | sed 's/\(.*ssid=.*$\)\(.*\)/\1'"$EXTRA"'\2/'  >> $FILE
wpa_cli -i wlan0 reconfigure
/etc/init.d/networking force-reload
/etc/init.d/networking start
