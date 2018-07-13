# docker-league-of-legends

Running League of Legends from a Docker container.

![lol](img/lol.jpg)

*** This no longer works ***

The client will launch and you can browse the store but you won't be able to start a game.

Details can be found here : https://boards.na.leagueoflegends.com/en/c/bug-report/sB4ucqXc-game-client-anti-cheat-changes-going-live

*****************************

My first experience of League of Legends was on a 7 year old laptop with Windows 7 installed. As a daily linux user however I would prefer to play on linux.

There are a number of ways to play League of Legends on linux.  Options include using PlayOnLinux or wine.  Most guides involve multiple manual steps, tweaks and workarounds. Please ensure you have at least the minimum spec of graphics card to run LoL. See the official documentation for more details.

As a Docker lover what if we could play League of Legends with a single command?  This script was tested on Ubuntu 17.10. I've been playing League of Legends daily using this setup for the past 3 months and haven't encountered any serious issues.

# Instructions

## Step 1 :

```
./league-of-legends.sh

```

The first time this script is run it will build the League of Legends container image, walk through the installation process and then start the client. At the end of the installation you will be prompted on whether you want to "Start League of Legends". You can leave this box ticked and click finish.

If the League of Legends client is not running and you want to start it just run : ./league-of-legends.sh 

That's it.  Expect more updates to this in the coming weeks.  GL;HF!


# Old instructions

## Step 1 : Build the container image

Build lol image :
```
docker build -t lol .
``` 

## Step 2 : Start the container

Start a container based on the lol image : 

We are sharing in 2 devices; sound and NVIDIA graphics card.  To find the device name of your graphics card run : `ls /dev/dri`
You should see a card0.  Add this into the second `--device` option below. We run `xhost +` to allow the container to connect to the Xserver on the host (for the current session only).

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

## Debugging

Logs :
```
docker exec -it league-of-legends /bin/bash -c "cd \"/root/.LoL64/drive_c/Riot Games/League of Legends/Logs/LeagueClient gs\" ; ls -rt |tail -2 |xargs tail -f"
```
