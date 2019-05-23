docker run -it --rm \
    --net host \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    -e USER=$USER \
    -e UART_GROUP_ID=20 \
    -e DISPLAY=$DISPLAY \
    -e VIVADO_VER=2018.2 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $HOME/docker/userhome:$HOME \
    -w $HOME \
    vivado2018.3 /bin/bash
