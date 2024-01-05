#!/bin/bash

USER_ID="$(id -u)"


OPTS=`getopt --options b:c:hi:p:r:st: \
         --long base-only:,cuda:,help,image-name:,pre-release:,ros-distro:,skip-uid-fix,tag-prefix: \
         --name "$0" -- "$@"`
eval set -- "$OPTS"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority

SHARED_DOCKER_DIR=/home/
SHARED_HOST_DIR=/home/whale/shared_dir

# AUTOWARE_DOCKER_DIR=/home/autoware/Autoware

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw"

# Create the shared directory in advance to ensure it is owned by the host user
# mkdir -p $SHARED_HOST_DIR

IMAGE=cedricxie/apollo-perception-ros:latest

echo "Launching $IMAGE"

docker run \
    -it --rm\
    -v ~/.ssh:/root/.ssh\
    # --gpus all\
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
