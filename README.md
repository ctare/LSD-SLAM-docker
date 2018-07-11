create container
```
docker build -t indigo-nvidia:lsd .
```

run
```
./run
```

test
```bash
roscore > /dev/null &; rosrun lsd_slam_viewer viewer # container1
rosbag play LSD_room.bag # container2
rosrun lsd_slam_core live_slam image:=/image_raw camera_info:=/camera_info #container3
```
