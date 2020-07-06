BUILD_DIR=$(pwd)

prepare_build_environment(){
    # Clean old build files
    rm -rf "${BUILD_DIR}"/build/*
    rm -rf "${BUILD_DIR}"/sources
    rm -rf "${BUILD_DIR:?}"/bin/*
    # Create directory for all sources
    mkdir -p "${BUILD_DIR}"/sources
    mkdir -p "${BUILD_DIR}"/bin
}

build_yasm(){
    cd "${BUILD_DIR}"/sources || exit
    curl -O -L https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
    tar xzvf yasm-1.3.0.tar.gz
    cd yasm-1.3.0
    ./configure --prefix="${BUILD_DIR}/build" --bindir="${BUILD_DIR}/bin"
    make -j4
    make install
}

build_nasm(){
    cd "${BUILD_DIR}"/sources || exit
    wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
    tar xjvf nasm-2.14.02.tar.bz2 && \
    cd nasm-2.14.02 && \
    ./autogen.sh && \
    PATH="$BUILD_DIR/bin:$PATH" ./configure --prefix="$BUILD_DIR/build" --bindir="$BUILD_DIR/bin" && \
    make && \
    make install
}

prepare_build_environment
build_yasm
build_nasm
