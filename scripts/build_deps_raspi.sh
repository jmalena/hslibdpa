#!/bin/bash

DIR=${BASH_SOURCE%/*}

pushd $DIR/../deps/clibspi
./buildMake.sh
popd

pushd $DIR/../deps/clibcdc
./buildMake.sh
popd

pushd $DIR/../deps/cutils
./buildMake.sh
popd

pushd $DIR/../deps/clibdpa
./buildMake.sh
popd
