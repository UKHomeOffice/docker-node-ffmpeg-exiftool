FROM node:9.8.0-alpine

ENV FFMPEG_VERSION=3.3.5
ENV EXIFTOOL_VERSION=10.20

RUN apk update && \
    apk upgrade && \

    apk add --update ca-certificates && \

    apk add gnutls-dev zlib-dev yasm-dev lame-dev libogg-dev \
    x264-dev libvpx-dev libvorbis-dev x265-dev freetype-dev \
    libass-dev libwebp-dev rtmpdump-dev libtheora-dev opus-dev && \

    apk add --no-cache --virtual .build-dependencies \
    build-base coreutils tar bzip2 x264 gnutls nasm && \

    wget -O- http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz | tar xzC /tmp && \
    cd /tmp/ffmpeg-${FFMPEG_VERSION} && \
    ./configure --bindir="/usr/bin" \
                --enable-version3 \
                --enable-gpl \
                --enable-nonfree \
                --enable-small \
                --enable-libmp3lame \
                --enable-libx264 \
                --enable-libx265 \
                --enable-libvpx \
                --enable-libtheora \
                --enable-libvorbis \
                --enable-libopus \
                --enable-libass \
                --enable-libwebp \
                --enable-librtmp \
                --enable-postproc \
                --enable-avresample \
                --enable-libfreetype \
                --enable-gnutls \
                --disable-debug && \
    make && \
    make install && \
    make distclean && \
    cd $OLDPWD && \

    rm -rf /tmp/ffmpeg-${FFMPEG_VERSION} && \
    apk del --purge .build-dependencies && \
    rm -rf /var/cache/apk/*

RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl
RUN apk add --no-cache perl make
RUN cd /tmp \
	&& wget http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz \
	&& tar -zxvf Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz \
	&& cd Image-ExifTool-${EXIFTOOL_VERSION} \
	&& perl Makefile.PL \
	&& make test \
	&& make install \
	&& cd .. \
	&& rm -rf Image-ExifTool-${EXIFTOOL_VERSION}