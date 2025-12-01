#!/bin/bash

# NOTES:
# --disable-shani (disable: -msse4 -msha )
# rhash should built without SSE4.1 which is incompatible with baseline of nocona PKG-10832

set -x

if [[ ${target_platform} =~ .*linux*. ]]; then
  RPATH="-Wl,-rpath-link,${PREFIX}/lib"
fi

export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib ${RPATH}"

./configure \
  --enable-openssl \
  --prefix=$PREFIX \
  --enable-lib-shared \
  --disable-shani \
  --extra-cflags="$CFLAGS -I$PREFIX/include" \
  --extra-ldflags="$LDFLAGS" \
  --ar=$AR

make install install-lib-headers install-lib-so-link
make check

if [[ ${HOST} =~ .*darwin.* ]]; then
  ${INSTALL_NAME_TOOL:-install_name_tool} -id @rpath/librhash.1.dylib ${PREFIX}/lib/librhash.1.dylib
fi
