#!/bin/bash

#gazebo
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install lsb-release wget gnupg
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get update
sudo apt-get install gz-garden


#ROS2
locale  # check for UTF-8
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
locale  # verify settings

sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt-get update && sudo apt-get upgrade
sudo apt install ros-humble-desktop
sudo apt install ros-humble-ros-base
sudo apt install ros-dev-tools
sudo apt-get install xfce4*

# Replace ".bash" with your shell if you're not using bash
# Possible values are: setup.bash, setup.sh, setup.zsh
source /opt/ros/humble/setup.bash

#trial ROS 2
#1st terminal
#source /opt/ros/humble/setup.bash
#ros2 run demo_nodes_cpp talker
#2nd terminal
#source /opt/ros/humble/setup.bash
#ros2 run demo_nodes_py listener



#Ardu Pilot
cd ~/
git clone https://github.com/ArduPilot/ardupilot.git
cd ardupilot
git checkout e9f46b9
git submodule update --init --recursive

#ubuntu 22.04 Ardupilot pre-requisite
cd ~/ardupilot
cd Tools/environment_install/
rm install-prereqs-ubuntu.sh
wget https://raw.githubusercontent.com/ArduPilot/ardupilot/master/Tools/environment_install/install-prereqs-ubuntu.sh
cd ~/ardupilot
chmod +x Tools/environment_install/install-prereqs-ubuntu.sh
Tools/environment_install/install-prereqs-ubuntu.sh -y
. ~/.profile

#ArduPilot Plug-in
sudo apt install libgz-sim7-dev rapidjson-dev

#Trying ardu pilot
sim_vehicle.py -v ArduSub -L RATBeach --console --map

cd ~/
git clone https://github.com/ArduPilot/ardupilot_gazebo
cd ardupilot_gazebo
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j4






#SUAVE
#pip dependency
#pip3 uninstall em
#pip3 uninstall empy
#pip3 uninstall 'empy<4'

mkdir -p ~/suave_ws/src/
cd ~/suave_ws/

#LATEST
wget https://raw.githubusercontent.com/kas-lab/suave/main/suave.rosinstall
vcs import src < suave.rosinstall --recursive

#SEAMS2023
#wget https://raw.githubusercontent.com/kas-lab/suave/9e6468896ce766376557ca9522d84f92b70129f1/suave.rosinstall
#vcs import src < suave.rosinstall --recursive

export GZ_VERSION="garden"

source /opt/ros/humble/setup.bash
cd ~/suave_ws/
sudo rosdep init
rosdep update
rosdep install --from-paths src --ignore-src -r -y

cd ~/suave_ws/

#Colcon fix ament (depedency issue)
# Source ROS 2 setup file
source /opt/ros/humble/setup.bash 
rosdep install --from-paths src --ignore-src --rosdistro humble -y # Install dependencies

# Build the workspace
colcon build --symlink-install
colcon build --symlink-install --executor sequential --parallel-workers 1

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
sudo bash ./install_geographiclib_datasets.sh


#Continue Ardu pilot
echo 'export GZ_SIM_SYSTEM_PLUGIN_PATH=$HOME/ardupilot_gazebo/build:${GZ_SIM_SYSTEM_PLUGIN_PATH}' >> ~/.bashrc
echo 'export GZ_SIM_RESOURCE_PATH=$HOME/ardupilot_gazebo/models:$HOME/ardupilot_gazebo/worlds:${GZ_SIM_RESOURCE_PATH}' >> ~/.bashrc

source ~/.bashrc



