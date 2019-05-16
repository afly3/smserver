#!/bin/bash
CONTAINER=rtsp-rtmp-server
sudo xhost +
sudo docker run -it -e DISPLAY=unix$DISPLAY --net=host \
     --ulimit core=-1 --security-opt seccomp=unconfined \
     --name=$CONTAINER --privileged \
     -v /tmp/.X11-unix/:/tmp/.X11-unix/ \
     -v /etc/localtime:/etc/localtime:ro \
     -v /etc/timezone:/etc/timezone:ro \
     -v "$HOME/zelu/clion-2018.2.4":"/home/clion-2018.2.4" \
     -v "$HOME/zelu/.CLion2018.2":"/root/.CLion2018.2" \
     -v /etc/hosts:/etc/hosts \
     -v /usr/lib/x86_64-linux-gnu/libnvcuvid.so:/usr/lib/x86_64-linux-gnu/libnvcuvid.so:ro \
     -v /usr/lib/x86_64-linux-gnu/libcuda.so:/usr/lib/x86_64-linux-gnu/libcuda.so:ro \
     -v $(pwd)/clion.sh:/home/clion.sh \
     -v /data/zhaoyunfei/rtsp-rtmp-server:/home/rtspserver -w /home \
     docker.dg-atlas.com:5000/vse_dev:v1.3 /bin/bash
