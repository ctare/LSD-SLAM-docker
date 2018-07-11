create container
```
docker build -t indigo-nvidia:lsd .
```

run
```
./run
```

test
```
roscore > /dev/null &; rosrun lsd_slam_viewer viewer # container1
rosbag play ~/catkin_lsdslam/LSD_room.bag # container2
rosrun lsd_slam_core live_slam image:=/image_raw camera_info:=/camera_info #container3
```
