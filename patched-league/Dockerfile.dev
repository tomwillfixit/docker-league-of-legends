FROM ubuntu:18.04

RUN dpkg --add-architecture i386

RUN apt-get update

ADD wine /opt/wine

WORKDIR /opt/wine

RUN apt-get install autoconf git -y
RUN apt-get build-dep wine -y

# 32 bit Build Dependencies
RUN apt-get install -y lib32ncurses5 gcc-multilib g++-multilib libx11-dev:i386 libfreetype6-dev:i386 lib32z1 libgtk2.0-0:i386 libidn11:i386 libglu1-mesa:i386 libxmu6:i386 libpangox-1.0-0:i386 libpangoxft-1.0-0:i386

RUN ./configure

ADD wine-staging /opt/wine-staging

RUN cp -r /opt/wine-staging/* /opt/wine

RUN ./patches/patchinstall.sh DESTDIR="/opt/wine" --all

RUN echo break cache

ADD andrew_patches /opt/wine/andrew_patches

RUN for p in `ls andrew_patches/000*`;do patch -p1 < ${p} ; sleep 2 ; done

RUN CFLAGS="--with-gnutls" make -j5

RUN make install

ADD lol.exe /root/lol.exe

COPY client/preinstalled_client1 /root/preinstalled_client1
COPY client/preinstalled_client2 /root/preinstalled_client2
COPY client/preinstalled_client3 /root/preinstalled_client3

RUN cat /root/preinstalled_client* > /root/Lol_installed.tar

COPY scripts/start_league /root/start_league

VOLUME /root

#tls ssl errors
RUN apt-get install winbind libntlm0 -y

# Install winetricks
RUN apt-get install wget -y
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && chmod +x winetricks
RUN apt-get install cabextract -y

# Install Direct X
RUN WINEPREFIX=~/.LoL ./winetricks d3dx9

WORKDIR /root
ENTRYPOINT ["/bin/bash"]

CMD ["./start_league"]

