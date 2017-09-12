#!/bin/bash

if [[ ${HOST} =~ .*linux.* ]]; then
  make ADDCFLAGS="${CFLAGS}" ADDLDFLAGS="${LDFLAGS}" install-lib-static
  make             PREFIX="" CC="${CC}" CFLAGS="${CFLAGS}" DESTDIR="${PREFIX}" install-shared
  make -C librhash PREFIX="" CC="${CC}" CFLAGS="${CFLAGS}" DESTDIR="${PREFIX}"         install-lib-shared install-lib-static
elif [[ ${HOST} =~ .*darwin.* ]]; then
  make             PREFIX="" CC="${CC}" CFLAGS="${CFLAGS}" DESTDIR="${PREFIX}" install                    install-lib-static
  make -C librhash PREFIX="" CC="${CC}" CFLAGS="${CFLAGS}"                     dylib
  cp -a librhash/*.dylib* ${PREFIX}/lib
  # Following the Linux SONAME here.
  ${INSTALL_NAME_TOOL:-install_name_tool} -id @rpath/librhash.0.dylib ${PREFIX}/lib/librhash.0.dylib
fi

pushd tests
  ./test_rhash.sh
popd
