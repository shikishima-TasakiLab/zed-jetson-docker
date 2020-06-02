#!/bin/bash
DOCKER_DIR=$(dirname $(readlink -f $0))

if [[ -f ~/.bash_aliases ]]; then
    if [[ $(cat ~/.bash_aliases | grep zed-run) != "" ]]; then
        echo '"zed-run" is already exist.'
    else
        echo "alias zed-run='${DOCKER_DIR}/run-docker.sh'" >> ~/.bash_aliases
    fi

    if [[ $(cat ~/.bash_aliases | grep zed-exec) != "" ]]; then
        echo '"zed-exec" is already exist.'
    else
        echo "alias zed-exec='${DOCKER_DIR}/exec-docker.sh'" >> ~/.bash_aliases
    fi
else
    echo "alias zed-run='${DOCKER_DIR}/run-docker.sh'" >> ~/.bash_aliases
    echo "alias zed-exec='${DOCKER_DIR}/exec-docker.sh'" >> ~/.bash_aliases
fi
