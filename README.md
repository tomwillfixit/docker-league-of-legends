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

We are sharing in 3 devices; sound, onboard graphics card and NVIDIA graphics card.

```
docker run -it --net host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --device /dev/snd --security-opt seccomp:unconfined --name lol --device=/dev/dri/card0:/dev/dri/card0 --device=/dev/dri/card1:/dev/dri/card1 --entrypoint /bin/bash lol:latest
```

## Step 3 : Install DirectX
```
WINEPREFIX=~/.LoL64 ./winetricks d3dx9
```

## Step 4 : Configure wine

At this point, if Steps 1 to 3 were successful then you will be inside the container and we can run some commands to configure wine.

Run :
```
WINEPREFIX=~/.LoL64 winecfg
```

The wine UI will be displayed. 
```
--> You'll be prompted to install the Mono and Gecko packages. Just hit install and continue.  
--> Select the Staging tab and tick the "Enable CSMT box"

Exit wine.
```

## Step 5 : Install League of Legends

To start the LOL installer run :
```
WINEPREFIX=~/.LoL64 wine /opt/lol.exe
```
Accept the defaults and the installation should complete successfully.

## Step 6 : Start League of Legends and enjoy

The following command will start the client. Select the Region you wish to play in and the rest of the game will be downloaded.

```
WINEPREFIX=~/.LoL64 wine "/root/.LoL64/drive_c/Riot Games/League of Legends/LeagueClient.exe"
```

## Summary

While the above should just work it still needs some more refinement. More updates incoming.