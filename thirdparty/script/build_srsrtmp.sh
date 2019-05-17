#!/bin/bash
librtmpdir=$(pwd)/../srs-librtmp/src/srs
output=$(pwd)/../output
g++ ${librtmpdir}/srs_librtmp.cpp ${librtmpdir}/srs_librtmp.h -fPIC -shared -o ${output}/lib/libsrsrtmp.so
cp ${librtmpdir}/srs_librtmp.h ${output}/include
