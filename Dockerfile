# Using new minimal Ubuntu

FROM ubuntu:18.04

MAINTAINER tomwillfixit

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install wget software-properties-common -y

WORKDIR /root

# Install Wine
#RUN wget -nc https://repos.wine-staging.com/wine/Release.key 
RUN wget -nc https://dl.winehq.org/wine-builds/Release.key 
RUN apt-key add Release.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt-get update
RUN apt-get -o Dpkg::Options::="--force-overwrite" install --reinstall libsane1:i386 -y
RUN apt-get install --install-recommends winehq-staging -y

# Cleanup
RUN apt-get purge -y software-properties-common
RUN apt-get autoclean -y

# 2 Options to install : Provide the League-of-Legends installer exe or provide a preinstalled bundle
# COPY client/lol.exe /root/lol.exe
# or
# Copy in preinstalled client
#COPY client/preinstalled_client.tar /root/Lol64_installed.tar
COPY client/preinstalled_client1 /root/preinstalled_client1
COPY client/preinstalled_client2 /root/preinstalled_client2
COPY client/preinstalled_client3 /root/preinstalled_client3

RUN cat /root/preinstalled_client* > /root/Lol64_installed.tar

COPY scripts/start_league /root/start_league

VOLUME /root

ENTRYPOINT ["/bin/bash"]

CMD ["./start_league"]

