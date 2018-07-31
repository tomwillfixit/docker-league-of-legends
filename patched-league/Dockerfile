FROM ubuntu:18.04

RUN dpkg --add-architecture i386

RUN apt-get update

ADD wine /opt/wine

ADD wine-staging /opt/wine-staging

ADD patches /opt/wine/patches

WORKDIR /opt/wine-staging

RUN apt-get update && apt-get install autoconf git -y

RUN ./patches/patchinstall.sh DESTDIR="/opt/wine" --all

WORKDIR /opt/wine

RUN for p in `ls patches/000*`;do patch -p1 < ${p} ; sleep 2 ; done

RUN apt-get build-dep wine -y

# 32 bit Build Dependencies
RUN apt-get install -y lib32ncurses5 gcc-multilib g++-multilib libx11-dev:i386 libfreetype6-dev:i386 lib32z1 libgtk2.0-0:i386 libidn11:i386 libglu1-mesa:i386 libxmu6:i386 libpangox-1.0-0:i386 libpangoxft-1.0-0:i386

RUN ./configure

RUN make

RUN make install

ADD ../client/lol.exe /tmp/lol.exe

