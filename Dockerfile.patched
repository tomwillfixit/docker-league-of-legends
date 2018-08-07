FROM ubuntu:18.04 as amd64

COPY andrew_patches /andrew_patches

RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install tar git unzip dh-autoreconf flex bison curl

RUN mkdir /wine

WORKDIR /wine

RUN git clone -b v3.13.1 https://github.com/wine-staging/wine-staging.git && \
    git clone https://github.com/wine-mirror/wine && \
    cd wine && \
    git checkout 25cc380b8ed41652b135657ef7651beef2f20ae4

RUN ./wine-staging/patches/patchinstall.sh DESTDIR=./wine --all -W ntdll-futex-condition-var && \
    cd wine && \
    patch -p1 < /andrew_patches/0003-Pretend-to-have-a-wow64-dll.patch && \
    patch -p1 < /andrew_patches/0006-Refactor-LdrInitializeThunk.patch && \
    patch -p1 < /andrew_patches/0007-Refactor-RtlCreateUserThread-into-NtCreateThreadEx.patch && \
    patch -p1 < /andrew_patches/0009-Refactor-__wine_syscall_dispatcher-for-i386.patch && \
    patch -p1 < /andrew_patches/0010-New-Patch.patch && \
    cd .. && \
    apt-get -y build-dep wine && \
    mkdir lol-3.13.1-64 && \
    mkdir lol-3.13.1-32 && \
    cd lol-3.13.1-64 && \
    ../wine/configure --enable-win64 && \
    make -j8


FROM i386/ubuntu:18.04 as i386
COPY --from=amd64 /wine /wine 
RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install tar git unzip dh-autoreconf flex bison && \
    apt-get -y build-dep wine && \
    cd /wine/lol-3.13.1-32 && \
    ../wine/configure --with-win64=../lol-3.13.1-64 && \
    make -j8


#FROM i386/ubuntu:18.04 as final_image
#COPY --from=i386 /wine /wine

VOLUME /root

#RUN apt-get update && apt-get install make -y

COPY client/lol.exe /root/lol.exe
COPY scripts/start_patched_league /root/start_league

ENV WINEDLLOVERRIDES \"mscoree,mshtml=\"
ENV WINEPREFIX /root/.LoL
ENV WINEARCH win32

#RUN cd /wine/lol-3.13.1-32 && make install
 
ENTRYPOINT ["/bin/bash"]

CMD ["./start_league"]

