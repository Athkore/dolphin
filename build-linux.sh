#!/bin/bash -e
# build-linux.sh

CMAKE_FLAGS='-DLINUX_LOCAL_DEV=true -DENABLE_ANALYTICS=false -DCMAKE_INSTALL_PREFIX=/usr'

PLAYBACK_CODES_PATH="./Data/PlaybackGeckoCodes/"

DATA_SYS_PATH="./Data/Sys/"
BINARY_PATH="./build/Binaries/"

# Move into the build directory, run CMake, and compile the project
mkdir -p build
pushd build
cmake ${CMAKE_FLAGS} ../
make -j$(nproc)
make DESTDIR=../AppDir/ -j$(nproc) install
popd

# Copy the Sys folder in
cp -r -n ${DATA_SYS_PATH} ${BINARY_PATH}

touch ./build/Binaries/portable.txt
