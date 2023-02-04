#!/bin/bash
echo -n "{\"names\":["
iwlist wlan0 scan | grep 'SSID' | sed  "s/\(.*ESSID:\"\)\(.*\)\"$/\2/" | awk '{printf "%s\"%s\"",(NR==1?i"":","),$0}'a
echo -n "]}"




