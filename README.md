# docker-league-of-legends

Running League of Legends from a Docker container.

![lol](img/lol.jpg)

My first experience of League of Legends was on a 7 year old laptop with Windows 7 installed. As a daily linux user however I would prefer to play on linux.

There are a number of ways to play League of Legends on linux.  Options include using PlayOnLinux or wine.  Most guides involve multiple manual steps, tweaks and workarounds. Please ensure you have at least the minimum spec of graphics card to run LoL. See the official documentation for more details.

As a Docker lover what if we could play League of Legends with a single Docker command?

Spoiler Alert : I haven't got this refined down to a single command but the following steps will get you started.


## Step 1 : Build the container image

Build lol image :
```
docker build -t lol .
``` 

## Step 2 : Start the container

Start a container based on the lol image : 

We are sharing in 2 devices; sound and NVIDIA graphics card.  To find the device name of your graphics card run : `ls /dev/dri`
You should see a card0.  Add this into the second `--device` option below. We run `xhost +` to allow the container to connect to the Xserver on the host.

Example : 
```
xhost +

docker run -it --net host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/snd --security-opt seccomp:unconfined --name lol --device=/dev/dri/card0:/dev/dri/card0 --entrypoint /bin/bash lol:latest
```

## Step 3 : Install League of Legends

To start the LOL installer run :
```
WINEPREFIX=~/.LoL64 wine /root/lol.exe
```
Accept the defaults and the installation should complete successfully. Untick the "Start League of Legends" box in the final screen and click exit.

## Step 4 : Start League of Legends and enjoy

The following command will start the client. Select the Region you wish to play in and the rest of the game will be downloaded.

```
WINEPREFIX=~/.LoL64 wine "/root/.LoL64/drive_c/Riot Games/League of Legends/LeagueClient.exe"
```
## Restarting the game

Here are 2 helper aliases that can be used to start and stop League of Legends. You can add these to your ~/bash_aliases file.
```
alias startlol="xhost + ; docker start lol ; docker exec -it lol /bin/bash -c \"WINEPREFIX=~/.LoL64 wine '/root/.LoL64/drive_c/Riot Games/League of Legends/LeagueClient.exe'\""

alias stoplol="docker stop lol"
```
## Removing the game

Careful now : If you remove the lol container you will lose the downloaded client from Step 4.  To completely remove the lol container and the lol image run :
```
docker rm -f lol
docker rmi lol:latest
```

## Summary

While the above should just work it still needs some more refinement. More updates incoming.
