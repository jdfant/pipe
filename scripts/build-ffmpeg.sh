BUILD_DIR=$(pwd)

prepare_build_environment(){
    # Clean old build files
    rm -rf "${BUILD_DIR}"/ffmpeg_build/*
    rm -rf "${BUILD_DIR}"/ffmpeg_sources
    rm -rf "${BUILD_DIR:?}"/bin/*
    # Create directory for all sources
    mkdir -p "${BUILD_DIR}"/ffmpeg_sources
    mkdir -p "${BUILD_DIR}"/bin
    mkdir -p "${BUILD_DIR}"/ffmpeg-skel/usr/bin/
}

build_yasm(){
    cd "${BUILD_DIR}"/ffmpeg_sources || exit
    curl -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    tar xzvf yasm-1.3.0.tar.gz
    cd yasm-1.3.0
    ./configure --prefix="${BUILD_DIR}/ffmpeg_build" --bindir="${BUILD_DIR}/bin"
    make -j4
    make install
}

build_libvpx(){
    cd "${BUILD_DIR}"/ffmpeg_sources || exit
    git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
    cd libvpx
    PATH="${BUILD_DIR}/bin:$PATH" ./configure --prefix="${BUILD_DIR}/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
    PATH="${BUILD_DIR}/bin:$PATH" make -j4
    make install
}

build_ffmpeg(){
    cd "${BUILD_DIR}"/ffmpeg_sources || exit

    # Git version. Please read https://ffmpeg.org/download.html
    git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
    cd ffmpeg || exit

    PATH="${BUILD_DIR}/bin:$PATH" PKG_CONFIG_PATH="${BUILD_DIR}/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="${BUILD_DIR}/ffmpeg_build" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I${BUILD_DIR}/ffmpeg_build/include" \
    --extra-ldflags="-L${BUILD_DIR}/ffmpeg_build/lib" \
    --extra-libs=-lpthread \
    --extra-libs=-lm \
    --bindir="${BUILD_DIR}/bin" \
    --enable-gpl \
    --enable-libvpx
    make -j4
    make install
}

prepare_build_environment
build_yasm
build_libvpx
build_ffmpeg
