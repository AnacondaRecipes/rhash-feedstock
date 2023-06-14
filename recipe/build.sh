#!/bin/bash
set -x

if [[ ${target_platform} =~ .*linux*. ]]; then
  RPATH="-Wl,-rpath-link,${PREFIX}/lib"
elif [[ ${target_platform} == osx-64 ]]; then
  RPATH="-Wl,-rpath,${PREFIX}/lib"
fi

export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib ${RPATH}"

./configure \
  --enable-openssl \
  --prefix=$PREFIX \
  --enable-lib-static \
  --enable-lib-shared \
  --extra-cflags="$CFLAGS -I$PREFIX/include" \
  --extra-ldflags="$LDFLAGS" \
  --ar=$AR

make install install-lib-headers install-lib-so-link
make check

if [[ ${HOST} =~ .*darwin.* ]]; then
  ${INSTALL_NAME_TOOL:-install_name_tool} -id @rpath/librhash.0.dylib ${PREFIX}/lib/librhash.0.dylib
fi
