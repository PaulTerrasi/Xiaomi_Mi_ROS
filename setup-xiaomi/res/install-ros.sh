#!/bin/bash

# Update the apt repo
echo "Updating apt repo..."
sudo apt-get --yes --force-yes update

# Install lsb-release
echo "Installing lsb-release..."
sudo apt-get --yes --force-yes install lsb-release

# Get ros apt repo
echo "Fetching ROS apt repo..."
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# Set up keys
echo "Setting up keys for ROS..."
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# Install ros-base
echo "Updating apt repo..."
sudo apt-get --yes --force-yes update

echo "Installing ROS Indigo..."
sudo apt-get --yes --force-yes install ros-indigo-ros-base

# Initialize rosdep
echo "Initializing rosdep..."
sudo rosdep init
rosdep update

# Install Python setuptools
echo "Installing python setup tools..."
sudo apt-get --yes --force-yes install python-setuptools

# Install PySerial
echo "Installing pyserial..."
sudo easy_install pyserial
