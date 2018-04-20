# Configuring ROS on a Xiaomi Robot - EECE5698 Group 7

This repository contains scripts and files relevant to hacking into a Xiaomi
Generation 1 Vacuum Robot, installing ROS, and writing drivers.

## Enabling SSH into the operating system

This is done using scripts and instructions provided by 
[Dustcloud](https://github.com/dgiese/dustcloud). Download their repository using

```
git clone https://github.com/dgiese/dustcloud.git
```

The following are a simplified version of their instructions for flashing the 
robot to enable SSH with a user generated key.

### Dependencies

* [python-miio](https://github.com/rytilahti/python-miio)
* ccrypt - `sudo apt-get install ccrypt`
* wget - `sudo apt-get install wget`

### Generating the firmware image

Download the latest base firmware image from 
https://dustcloud.seemoo.de/public/xiaomi.vacuum.gen1/original/encrypted/, 
and place it into a working directory. Download the english sound package by
running the following command inside of your working directory:

```
wget https://github.com/dgiese/dustcloud/raw/master/devices/xiaomi.vacuum/original-soundpackages/encrypted/english.pkg
```

Create an ssh key pair using by running:

```
ssh-keygen -t rsa -b 4096
```

Finally run the image builder with the downloading base firmware image and the
public key (ending in .pub) that you generated:

```
./dustcloud/devices/xiaomi.vacuum/firmwarebuilder/imagebuilder.sh -f <your firmware package> -k <your public key>
```


### Flashing the Firmware and SSHing in

Put the robot onto its charger. It should be generating a wifi network name 
starting with rockrobo-vacuum-v1. Then run the following command:

```
python3 dustcloud/devices/xiaomi.vacuum/firmwarebuilder/flasher.py -f output/<your firmware package>
```

Once completed, the robot will update. When it is done, it will say 
"Update Completed." At this point, you can ssh into the robot with the
following command, using your **private key** (with no file extension):

```
ssh -i <your private key> root@192.168.8.1
```

### Factory resetting the robot

If it is necessary to perform a factory restore of the robot's operating 
system, this can be done by holding down the home button, then simultaneously
holding down the reset button for 5 seconds. Let go of the reset button,
continuing to hold the home button until it begins to flash. Once you are able
to connect back to the robot's wifi, flash the firmware back onto the robot.


## Configuring the robot with ROS

The entire process of connecting the robot to wifi, installing python,
installing ROS, installing PySerial, and installing git is performed
automatically. Start by copying this repository onto the robot using:

```
scp -r -i <your private key> vacuum-repo/ root@192.168.8.1:~
```

From here, ssh into the robot, and then execute the following:

```
cd vacuum-repo/setup-xiaomi
source setup-xiaomi.sh <network name>
```

Where network name is the name of an unsecured wifi network that you would
like the robot to connect to. This will distribute all of the installed
files between the root partition and a duplicate root folder on the /mnt/data
partition, in order to work around hard disk space limitations.

NOTE: THIS SCRIPT WILL DOWNLOAD ABOUT 1GB OF DATA. DO NOT USE WITH A DATA
LIMITED NETWORK.


## Visualizing Lidar output

Follow instructions under xiaomi\_ws folder (main ROS workspace)
