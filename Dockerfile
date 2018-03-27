FROM ubuntu:artful

MAINTAINER tomwillfixit

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install wget software-properties-common python-software-properties -y

WORKDIR /root

RUN wget -nc https://repos.wine-staging.com/wine/Release.key 
RUN apt-key add Release.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt-get update
RUN apt-get -o Dpkg::Options::="--force-overwrite" install --reinstall libsane1:i386 -y
RUN apt-get install --install-recommends winehq-staging -y

RUN apt-get purge -y software-properties-common
RUN apt-get autoclean -y

# Install winetricks
RUN apt-get install wget -y
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks
RUN apt-get install cabextract -y

# Add LOL exe installer to image. This was downloaded from : https://signup.na.leagueoflegends.com/en/signup/redownload

COPY lol.exe /root/lol.exe

VOLUME /root
