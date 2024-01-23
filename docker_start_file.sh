#!/bin/bash
set -e
# Default settings
CUDA="on"
ROS_DISTRO="melodic"
USER_ID="$(id -u)"

function usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "    -c,--cuda <on|off>                 Enable Cuda support in the Docker."
    echo "                                       Default: $CUDA"
    echo "    -h,--help                          Display the usage and exit."
    echo "    -i,--image <name>                  Set docker images name."
    echo "                                       Default: $IMAGE_NAME"
    echo "    -p,--pre-release <on|off>          Use pre-release image."
    echo "                                       Default: $PRE_RELEASE"
    echo "    -r,--ros-distro <name>             Set ROS distribution name."
    echo "                                       Default: $ROS_DISTRO"
    echo "    -s,--skip-uid-fix                  Skip uid modification step required when host uid != 1000"
    echo "    -t,--tag-prefix <tag>              Tag prefix use for the docker images."
    echo "                                       Default: $TAG_PREFIX"
}

OPTS=`getopt --options b:c:hi:p:r:st: \
         --long base-only:,cuda:,help,image-name:,pre-release:,ros-distro:,skip-uid-fix,tag-prefix: \
         --name "$0" -- "$@"`
eval set -- "$OPTS"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority

SHARED_DOCKER_DIR=/home/
# 此处为本机的目录
SHARED_HOST_DIR=/home/whale/code/

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw"

# DOCKER_VERSION=$(docker version --format '{{.Client.Version}}' | cut --delimiter=. --fields=1,2)
# if [ $CUDA == "on" ]; then
#     SUFFIX=$SUFFIX"-cuda"
#     if [[ ! $DOCKER_VERSION < "19.03" ]] && ! type nvidia-docker; then
#         RUNTIME="--gpus all"
#     else
#         RUNTIME="--runtime=nvidia"
#     fi
# fi

# if [ $PRE_RELEASE == "on" ]; then
#     SUFFIX=$SUFFIX"-rc"
# fi
# 此处修改为等待启动的镜像
IMAGE=robest_melodic/ros-melodic-full:V1

echo "Launching $IMAGE"

docker run \
    -it --rm\
    -v ~/.ssh:/root/.ssh\
    $VOLUMES \
    --gpus all \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --env="USER_ID=$USER_ID" \
    --privileged \
    --net=host \
    -w /home/\
    $RUNTIME \
    $IMAGE


# 默认设置
# CUDA="off"
# IMAGE_NAME="fishros2/ros"
# TAG_PREFIX="melodic-desktop-full"
# ROS_DISTRO="melodic"
# BASE_ONLY="false"
# PRE_RELEASE="off"
# AUTOWARE_HOST_DIR="/home/whale/RBD_ws/RoBest_Car/beilu_ws"
# USER_ID=$(id -u)

# function usage() {
#     echo "Usage: $0 [OPTIONS]"
#     # ...省略其他选项...
# }

# # Convert a relative directory path to absolute
# function abspath() {
#     local path=$1
#     if [ ! -d $path ]; then
#     exit 1
#     fi
#     pushd $path > /dev/null
#     echo $(pwd)
#     popd > /dev/null
# }

# # 检查CUDA是否可用
# function check_cuda() {
#     if lspci | grep -q 'NVIDIA'; then
#         if nvidia-smi > /dev/null 2>&1; then
#             CUDA="on"
#         fi
#     fi
# }

# check_cuda
