#!/bin/bash

CONTAINER_NAME="zed-ros"
ZED_LAUNCH="on"

PROG_NAME=$(basename $0)
RUN_DIR=$(dirname $(readlink -f $0))

function usage_exit {
  cat <<_EOS_ 1>&2
  Usage: $PROG_NAME [OPTIONS...]
  OPTIONS:
    -h, --help              このヘルプを表示
    -l, --launch {on|off}   ZED ROSノードの起動のON/OFFを切り替える（既定値：on）
    -n, --name NAME         コンテナの名前を指定
_EOS_
    cd ${CURRENT_DIR}
    exit 1
}

while (( $# > 0 )); do
    if [[ $1 == "--help" ]] || [[ $1 == "-h" ]]; then
        usage_exit
    elif [[ $1 == "--launch" ]] || [[ $1 == "-l" ]]; then
        if [[ $2 == "on" ]] || [[ $2 == "off" ]]; then
            ZED_LAUNCH=$2
        else
            echo "無効なパラメータ： $1 $2"
            usage_exit
        fi
        shift 2
    elif [[ $1 == "--name" ]] || [[ $1 == "-n" ]]; then
        if [[ $2 == -* ]] || [[ $2 == *- ]]; then
            echo "無効なパラメータ： $1 $2"
            usage_exit
        fi
        CONTAINER_NAME=$2
        shift 2
    else
        echo "無効なパラメータ： $1"
        usage_exit
    fi
done

DOCKER_IMAGE="stereolabs/zed:3.1-ros-devel-jetson-jp4.3"

XSOCK="/tmp/.X11-unix"
XAUTH="/tmp/.docker.xauth"
ASOCK="/tmp/pulseaudio.socket"
ACKIE="/tmp/pulseaudio.cookie"
ACONF="/tmp/pulseaudio.client.conf"

DOCKER_VOLUME="-v ${XSOCK}:${XSOCK}:rw"
DOCKER_VOLUME="${DOCKER_VOLUME} -v ${XAUTH}:${XAUTH}:rw"
DOCKER_VOLUME="${DOCKER_VOLUME} -v ${ASOCK}:${ASOCK}"
DOCKER_VOLUME="${DOCKER_VOLUME} -v ${ACONF}:/etc/pulse/client.conf"

DOCKER_ENV="-e XAUTHORITY=${XAUTH}"
DOCKER_ENV="${DOCKER_ENV} -e DISPLAY=$DISPLAY"
DOCKER_ENV="${DOCKER_ENV} -e TERM=xterm-256color"
DOCKER_ENV="${DOCKER_ENV} -e PULSE_SERVER=unix:${ASOCK}"
DOCKER_ENV="${DOCKER_ENV} -e PULSE_COOKIE=${ACKIE}"

DOCKER_NET="host"

DOCKER_CMD=""

if [[ ${ZED_LAUNCH} == "on" ]]; then
    DOCKER_CMD="roslaunch src/zed-ros-wrapper/zed_wrapper/launch/zed_no_tf.launch"
fi

if [[ ! -S ${ASOCK} ]]; then
    pacmd load-module module-native-protocol-unix socket=${ASOCK}
fi

if [[ ! -f ${ACONF} ]]; then
    touch ${ACONF}
    echo "default-server = unix:${ASOCK}" > ${ACONF}
    echo "autospawn = no" >> ${ACONF}
    echo "daemon-binary = /bin/true" >> ${ACONF}
    echo "enable-shm = false" >> ${ACONF}
fi

touch ${XAUTH}
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge -

docker run \
    --rm \
    -it \
    --gpus all \
    --privileged \
    --name ${CONTAINER_NAME} \
    --net ${DOCKER_NET} \
    ${DOCKER_ENV} \
    ${DOCKER_VOLUME} \
    ${DOCKER_IMAGE} \
    ${DOCKER_CMD}
