BUILD_DIR=$(pwd)

# For "Stable" and/or 3.0.2 versions.
#FFMPEG_VERSION=3.0.2

prepare_build_environment(){
    # Clean old build files
    rm -rf "${BUILD_DIR}"/build/ffmpeg_build/*
    # Clean "$BUILD_DIR"/bin
    rm -rf "${BUILD_DIR:?}"/bin/*
    # Create directory for all sources
    rm -rf "${BUILD_DIR}"/build/ffmpeg_sources
    mkdir -p "${BUILD_DIR}"/build/ffmpeg_sources
    mkdir -p "${BUILD_DIR}"/ffmpeg-skel/usr/bin/
}

app_check(){
    # curl and git must be installed for this to work
    if hash curl 2>/dev/null;then
        echo -n
    else
        echo -e "\nPlease install curl, then re-eun this script"
        exit 1
    fi
    if hash git 2>/dev/null;then
        echo -n
    else
        echo -e "\nPlease install git, then re-eun this script"
        exit 1
    fi
}

build_yasm(){
    # Download and compile Yasm
    cd "${BUILD_DIR}"/build/ffmpeg_sources || exit
    rm -rf yasm-1.3.0
    curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    tar xzvf yasm-1.3.0.tar.gz
    cd yasm-1.3.0 || exit
    ./configure --prefix="${BUILD_DIR}/build/ffmpeg_build" --bindir="${BUILD_DIR}/bin"
    make
    make install
}

build_libvpx(){
    cd "${BUILD_DIR}"/build/ffmpeg_sources || exit
    git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
    cd libvpx || exit
    ./configure --prefix="${BUILD_DIR}/build/ffmpeg_build" --disable-examples  --as=yasm
    PATH="${BUILD_DIR}/bin:${PATH}" make
    make install
}

build_ffmpeg(){
    cd "${BUILD_DIR}"/build/ffmpeg_sources || exit
    # Older version:
    # curl -O http://ffmpeg.org/releases/ffmpeg-3.0.2.tar.bz2

    # "Stable" version:
    #curl -O http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
    #tar xjvf ffmpeg-${FFMPEG_VERSION}.tar.bz2

    # For "Stable" and/or 3.0.2 versions.
    #cd ffmpeg-${FFMPEG_VERSION}

    # Git version. Please read https://ffmpeg.org/download.html
    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
    cd ffmpeg || exit

    PKG_CONFIG_PATH="${BUILD_DIR}/build/ffmpeg_build/lib/pkgconfig" ./configure --enable-gpl \
    --prefix="${BUILD_DIR}/build/ffmpeg_build" --extra-cflags="-I${BUILD_DIR}/build/ffmpeg_build/include" \
    --extra-ldflags="-L${BUILD_DIR}/build/ffmpeg_build/lib -ldl" --bindir="${BUILD_DIR}/bin" \
    --pkg-config-flags="--static" --enable-libvpx
    make
    make install
    hash -r
}

transfer_files(){
    cp "${BUILD_DIR}"/bin/ff{mpeg,server} "${BUILD_DIR}"/ffmpeg-skel/usr/bin/
}

prepare_build_environment
app_check
build_yasm
build_libvpx
build_ffmpeg
transfer_files
