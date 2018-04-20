sudo ifconfig wlan1 up
iw dev wlan1 connect hot
sudo dhclient wlan1 -v
