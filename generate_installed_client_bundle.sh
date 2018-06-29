#!/bin/bash

# Description : Builds a client bundle which includes everything needed by wine to start LoL.

xhost +

today=$(date +%F)

# Build Image

docker build -t league-of-legends:client_bundle .

docker create -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/snd --security-opt seccomp:unconfined --name client_bundle --device=/dev/dri/card0:/dev/dri/card0 --entrypoint /bin/bash league-of-legends:client_bundle -c "sleep 300"

docker start client_bundle

# Start Container and Install League
docker exec -it client_bundle /bin/bash -c "export WINEDLLOVERRIDES="mscoree,mshtml=" ; export WINEPREFIX=/root/.LoL64 ; wine /root/lol.exe --mode unattended ; sleep 20"

if [ $? -eq 0 ];then
    echo "League of Legends installed"
    echo "Creating the Client Bundle"
    docker exec -it client_bundle /bin/bash -c "cd /root ; tar --exclude='.LoL64/dosdevices*' --exclude='.LoL64/drive_c/users/root/My*' -cvf LoL64_installed_${today}.tar .LoL64"
    docker cp client_bundle:/root/LoL64_installed_${today}.tar . 
    echo "Client Bundle created :"
    ls -lart LoL64_installed_${today}.tar
else
    echo "Something broke during the wine /root/lol.exe --mode unattended command"
    exit 1
fi

# todo : split the bundle to stay below 100mb limit in github
# split -b 90M preinstalled_client.tar "preinstalled_client"
# Copy Client Bundle out of container

docker rm -f client_bundle
