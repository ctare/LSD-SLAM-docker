FROM osrf/ros:indigo-desktop-full
LABEL com.nvidia.volumes.needed="nvidia_driver"

WORKDIR /root/

ENV DISPLAY $DISPLAY
ENV QT_X11_NO_MITSHM 1
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}
RUN apt-get update
RUN apt-get install x11-apps vim wget zip -y
RUN apt-get install software-properties-common --force-yes --force-yes -y

RUN apt-get install python-software-properties -y
RUN add-apt-repository --yes ppa:xqms/opencv-nonfree
RUN apt-get update -y
RUN apt-get install libopencv-nonfree-dev=2.4.8+dfsg1-2ubuntu1xqms1~trusty1 -y

RUN apt-get install ros-indigo-libg2o ros-indigo-cv-bridge liblapack-dev libblas-dev freeglut3-dev libqglviewer-dev libsuitesparse-dev libx11-dev -y

RUN mkdir rosbuild_ws && cd rosbuild_ws && \
	rosws init . /opt/ros/indigo && \
	mkdir package_dir && \
	rosws set -y ~/rosbuild_ws/package_dir -t . && \
	echo "source ~/rosbuild_ws/setup.bash" >> ~/.bashrc && \
	cd package_dir && \
	git clone https://github.com/tum-vision/lsd_slam.git lsd_slam
	
RUN cd rosbuild_ws/package_dir && \
	sed -i "/^#.*openFabMap/s/^#//" ./lsd_slam/lsd_slam_core/CMakeLists.txt && \
	sed -i "/^#.*FABMAP/s/^#//" ./lsd_slam/lsd_slam_core/CMakeLists.txt && \
	sed -i "/gen.add/s/'//g" ./lsd_slam/lsd_slam_core/cfg/* ./lsd_slam/lsd_slam_viewer/cfg/*

RUN rosdep update
RUN /bin/bash -c "source rosbuild_ws/setup.bash && cd rosbuild_ws && rosmake lsd_slam"

RUN wget http://vmcremers8.informatik.tu-muenchen.de/lsd/LSD_room.bag.zip
RUN unzip LSD_room.bag.zip
