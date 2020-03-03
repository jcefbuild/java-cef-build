#!/bin/bash -e

mkdir -p $JCEF_DIR/jcef_build
cd $JCEF_DIR/jcef_build

# generate build script with cmake
if [ "$TRAVIS_OS_NAME" = 'osx' ]; then
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DPROJECT_ARCH="x86_64" ../
else
  cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=$CC -DCMAKE_CXX_COMPILER=$CXX ../
fi

# build the library
set -x
ninja
set +x

cd ../tools

# compile the java source on Linux
if [ "$TRAVIS_OS_NAME" = 'linux' ]; then
  ./compile.sh $ARCH_DIST
fi

# generate docs, copy libraries and jars to binary_distrib folder, etc
./make_distrib.sh $ARCH_DIST
