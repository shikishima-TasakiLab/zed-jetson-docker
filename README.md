# ZED-Jetson-Docker

This repository has scripts to run a Docker container for the ZED-SDK and ROS nodes on Jetson.

|                  |                                                                                    |
|------------------|------------------------------------------------------------------------------------|
|Official DockerHub|[https://hub.docker.com/r/stereolabs/zed/](https://hub.docker.com/r/stereolabs/zed/)|
|Official GitHub   |[https://github.com/stereolabs/zed-docker](https://github.com/stereolabs/zed-docker)|

## Installation

```bash
#!/bin/bash

# Git Clone
git clone https://github.com/shikishima-TasakiLab/zed-jetson-docker.git ZED-Jetson-Docker

# Set aliases
cd ZED-Jetson-Docker
./docker/set-aliases.sh
source ~/.bashrc
```

## Usage

1. Run a Docker container.

    ```bash
    #!/bin/bash
    zed-run
    ```

    |Options         |Parameters|Description                      |Default  |Example          |
    |----------------|----------|---------------------------------|---------|-----------------|
    |`-h`, `--help`  |(None)    |Print help                       |(None)   |`-h`             |
    |`-l`, `--launch`|{on\|off} |Launch ROS Node                  |`on`     |`-l off`         |
    |`-n`, `--name`  |NAME      |Specify the name of the container|`zed-ros`|`-n my-container`|

1. When you want to use another terminal, run the following script.

    ```bash
    #!/bin/bash
    zed-exec
    ```

    |Options         |Parameters|Description                      |Default  |Example          |
    |----------------|----------|---------------------------------|---------|-----------------|
    |`-h`, `--help`  |(None)    |Print help                       |(None)   |`-h`             |
