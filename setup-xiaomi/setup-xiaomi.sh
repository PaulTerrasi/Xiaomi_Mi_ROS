#!/bin/bash

# This script configures a xiaomi vacuum robot by performing the following steps# - Connect to an unsecured wifi network
# - Install Python 2.7
# - Install ROS on the /mnt/data partition
# - Install PySerial on the /mnt/data partition
# - Install Git

# Displays a help message
show_help() {
    echo "This script configures a xiaomi vacuum robot by performing the following steps"
    echo "  - Connect to an unsecured wifi network"
    echo "  - Install Python 2.7"
    echo "  - Install ROS on the /mnt/data partition"
    echo "  - Install PySerial on the /mnt/data partition"
    echo "  - Install Git"
    echo
    echo "Usage: ./xiaomi-setup.sh [options] <network_name>"
    echo
    echo "  network name - The name of an unsecured wifi network to connect to"
    echo
    echo "Options:"
    echo "  -h Show help"
}

# Read in options
while [ -n "$1" ]; do
    case "$1" in
	-h) show_help
	    return;;
	-*) echo "Option $1 not recognized"
	   echo
	   show_help;;
	*) break;;
    esac
    shift
done

# Get network name
network="$1"

if [ -z "$network" ]; then
    echo "Please specify a network name to connect to"
    echo
    show_help
    exit
fi

# Connect robot to the network
echo "Connecting to network..."
ifconfig wlan1 up
eval "iw dev wlan1 connect $network"
dhclient -v wlan1

# Set the wifi_start.sh script (comes with the robot) to run on startup
# This is done because the robot will sometimes stop emitting a wifi hotspot,
# and the only way to fix it is to run this script. So with this restarting
# the robot will fix this problem

echo "Setting wifi_start.sh to run on startup..."
head -n -1 /etc/rc.local > /tmp/rc.local.tmp ; mv /tmp/rc.local.tmp /etc/rc.local

echo "./../opt/rockrobo/wlan/wifi_start.sh" >> /etc/rc.local
echo >> /etc/rc.local
echo "exit 0" >> /etc/rc.local

# Update the apt repo
echo "Updating apt repo..."
sudo apt-get --yes --force-yes update

# Install Python 2.7
echo "Installing Python 2.7..."
sudo apt-get --yes --force-yes install python2.7-minimal

# Create a root folder in /mnt/data

export JAIL="/mnt/data/root"

mkdir $JAIL

echo "Copying /bin to /mnt/data/root..."
cp -r /bin $JAIL

echo "Copying /boot to /mnt/data/root..."
cp -r /boot $JAIL

echo "Copying /dev to /mnt/data/root..."
cp -r /dev $JAIL

echo "Copying /etc to /mnt/data/root..."
cp -r /etc $JAIL

echo "Copying /home to /mnt/data/root..."
cp -r /home $JAIL

echo "Copying /lib to /mnt/data/root..."
cp -r /lib $JAIL

echo "Copying /root to /mnt/data/root..."
cp -r /root $JAIL

echo "Copying /sbin to /mnt/data/root..."
cp -r /sbin $JAIL

echo "Copying /srv to /mnt/data/root..."
cp -r /srv $JAIL

echo "Copying /tmp to /mnt/data/root..."
cp -r /tmp $JAIL

echo "Copying /usr to /mnt/data/root..."
cp -r /usr $JAIL

echo "Copying /var to /mnt/data/root..."
cp -r /var $JAIL

echo "Copying resource files to /mnt/data/root..."
cp res/install-ros.sh $JAIL
cp -R res/sources.list "${JAIL}/etc/apt/"

echo "Installing ROS with /mnt/data/root as root..."
# Now run the install ros script with /mnt/data/root as root
chroot $JAIL /bin/bash ./install-ros.sh

# Set up the ROS environment
echo "Setting up ROS environment..."
echo "source /mnt/data/root/opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc

# Point the python path to include modules installed in /mnt/data
echo "Setting python path to include modules installed in /mnt/data..."
export PYTHONPATH="${PYTHONPATH}:/mnt/data/root/opt/ros/indigo/lib/python2.7/dist-packages:/mnt/data/root/usr/lib/python2.7:/mnt/data/root/usr/lib/python2.7/plat-arm-linux-gnueabihf:/mnt/data/root/usr/lib/python2.7/lib-tk:/mnt/data/root/usr/lib/python2.7/lib-old:/mnt/data/root/usr/lib/python2.7/lib-dynload:/mnt/data/root/usr/local/lib/python2.7/dist-packages:/mnt/data/root/usr/lib/python2.7/dist-packages:/mnt/data/root/usr/lib/python2.7/dist-packages/wx-2.8-gtk2-unicode:/mnt/data/root/usr/local/lib/python2.7/dist-packages/pyserial-3.4-py2.7.egg"

# Install git
echo "Installing git"
sudo apt-get --yes --force-yes install git
