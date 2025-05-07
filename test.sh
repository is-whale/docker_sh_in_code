#/bin/bash
set -e

# Default settings
IMAGE_NAME="172.23.115.80/docker-local/ubuntu/22.04/module-base:v1.5"

SHARED_DOCKER_DIR=/home/

# 需要修改为本地代码路径
SHARED_HOST_DIR=/home/whale/code/marge/pull_code/

USER_ID="$(id -u)"

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority
VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw
         --volume=$SHARED_HOST_DIR:$SHARED_DOCKER_DIR:rw"
IMAGE=$IMAGE_NAME

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
    $IMAGE