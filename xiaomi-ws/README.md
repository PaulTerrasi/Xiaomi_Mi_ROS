# Setting up Lidar Visualization on computer

## Connect to same network as Vacuum

Can be done with external router/hotspot or using internal, vacuum-provided WiFi

## Setup ROS for multiple machines

Use instructions provided at [http://wiki.ros.org/ROS/Tutorials/MultipleMachines](http://wiki.ros.org/ROS/Tutorials/MultipleMachines)

Make sure ROS\_MASTER\_URI is the same for both visualization machine and vacuum

## Start Roscore on visualization machine

```
roscore
```

## Start rviz on visualization machine

```
rqt
```

Then under the `plugins` menu, select Visualization -> RViz

## Start driver on vacuum

Clone this repository

Install required build tools

```
sudo apt-get install build-essentials
```

Then, while in the `xiaomi_ws` folder, run:

```
catkin_make
source devel/setup.bash
rosrun xv_11_laser_driver neato_laser_publisher
```
