#########################################################################
# File Name: build_libyuv.sh
# Author: 赵云飞
# mail: yunfeizhao@deepglint.com a_fly0505@163.com
# Created Time: 2018年06月14日 星期四 17时31分29秒
#########################################################################
#!/bin/bash
set -x

OBJIN=../objs/include
OBJLIB=../objs/lib

LIBYUVDIR=../libyuv

if [ ! -d ${OBJIN} ];then
	mkdir -p ${OBJIN}
fi

if [ ! -d ${OBJLIB} ];then
	mkdir -p ${OBJLIB}
fi

rm -rf ${LIBYUVDIR}/build
cd ${LIBYUVDIR}
mkdir build
cd build
cmake .. && make -j8
cd ..
cp -rf ${LIBYUVDIR}/include/* ${OBJIN}
cp -rf ${LIBYUVDIR}/build/libyuv.a ${OBJLIB}
cd ..
