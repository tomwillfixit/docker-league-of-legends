#!/bin/bash

# DISCLAIMER : THIS NEEDS A TON MORE TESTING

xhost +

echo "Check if League of Legends is already running ..."
docker ps |grep "league-of-legends"

if [ $? -eq 0 ];then
    echo "The League of Legends container is already running."
    echo "Restarting the client"
    docker exec -it league-of-legends /bin/bash -c "WINEPREFIX=~/.LoL64 wine \"/root/.LoL64/drive_c/Riot Games/League of Legends/LeagueClient.exe\""
    exit 0
fi

echo "Checking for existing League of Legends container ..."

docker ps -a |grep "league-of-legends"
if [ $? -eq 0 ];then
    echo "Starting League of Legends ..."
    docker start league-of-legends
else
    echo "No League of Legends found."
    docker images |grep "league-of-legends" |grep "v1"
    if [ $? -eq 0 ];then
       echo "Found league-of-legends image."
       echo "Creating container and starting the client."
       docker create -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/snd --security-opt seccomp:unconfined --name league-of-legends --device=/dev/dri/card0:/dev/dri/card0 league-of-legends:v1 
       docker start league-of-legends
    else
       echo "No League of Legends image found."
       echo "Building Image and starting the client"
       docker build -t league-of-legends:v1 .
       docker create -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/snd --security-opt seccomp:unconfined --name league-of-legends --device=/dev/dri/card0:/dev/dri/card0 league-of-legends:v1
       docker start league-of-legends
    fi
fi
 
