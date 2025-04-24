#/bin/bash

set -e

# Default settings
IMAGE_NAME="bestway.com/docker-local/ubuntu/22.04/module-base:v1.4"

SHARED_DOCKER_DIR=/home/
SHARED_HOST_DIR=/home/whale/code/new_code_416/

CUDA="off"
ROS_DISTRO="melodic"
USER_ID="$(id -u)"
BASE_ONLY="false"
PRE_RELEASE="off"

SUFFIX="  "
RUNTIME=" "

OPTS=`getopt --options b:c:hi:p:r:st: \
         --long base-only:,cuda:,help,image-name:,pre-release:,ros-distro:,skip-uid-fix,tag-prefix: \
         --name "$0" -- "$@"`
eval set -- "$OPTS"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority



# AUTOWARE_DOCKER_DIR=/home/autoware/Autoware

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw"

DOCKER_VERSION=$(docker version --format '{{.Client.Version}}' | cut --delimiter=. --fields=1,2)
if [ $CUDA == "on" ]; then
    SUFFIX=$SUFFIX"-cuda"
    if [[ ! $DOCKER_VERSION < "19.03" ]] && ! type nvidia-docker; then
        RUNTIME="--gpus all"
    else
        RUNTIME="--runtime=nvidia"
    fi
fi

if [ $PRE_RELEASE == "on" ]; then
    SUFFIX=$SUFFIX"-rc"
fi

# Create the shared directory in advance to ensure it is owned by the host user
# mkdir -p $SHARED_HOST_DIR

IMAGE=$IMAGE_NAME$SUFFIX
# IMAGE=bestway.com/docker-local/ubuntu/22.04/module-base:v1.4$SUFFIX
# IMAGE=5d1c01ede155$SUFFIX


echo "Launching $IMAGE"

docker run \
    -it \
    -v ~/.ssh:/root/.ssh\
    $VOLUMES \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --env="USER_ID=$USER_ID" \
    --privileged \
    --net=host \
    -w /home/\
    $RUNTIME \
    $IMAGE

#     -it -rm \ -rm 参数用于在容器退出后自动删除容器

# [perf] judge if or no use cuda. but it is't by test. 
#!/bin/bash

# set -e

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
