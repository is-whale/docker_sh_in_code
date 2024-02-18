#/bin/bash
# Default settings
USER_ID="$(id -u)"

SUFFIX="  "
RUNTIME=" "

XSOCK=/tmp/.X11-unix
XAUTH=$HOME/.Xauthority

SHARED_DOCKER_DIR=/home/
SHARED_HOST_DIR=/home/whale/code/

VOLUMES="--volume=$XSOCK:$XSOCK:rw
         --volume=$XAUTH:$XAUTH:rw"

# IMAGE=$IMAGE_NAME:$TAG_PREFIX-$ROS_DISTRO$SUFFIX
IMAGE=carlasim/carla:0.9.12$SUFFIX

echo "Launching $IMAGE"

docker run \
    -it \
    --gpus all \
    $VOLUMES \
    --env="XAUTHORITY=${XAUTH}" \
    --env="DISPLAY=${DISPLAY}" \
    --env="USER_ID=$USER_ID" \
    --privileged \
    --net=host \
    $RUNTIME \
    $IMAGE