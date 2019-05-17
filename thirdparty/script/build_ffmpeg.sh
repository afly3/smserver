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

LIBFFMPEGDIR=../ffmpeg-3.4.1

if [ ! -d ${OBJIN} ];then
	mkdir -p ${OBJIN}
fi

if [ ! -d ${OBJLIB} ];then
	mkdir -p ${OBJLIB}
fi

cd ${LIBFFMPEGDIR}
./build.sh
make clean && make -j8 && make install
cp -rf ffmpeg-install/include/* ${OBJIN}
cp -rdf ffmpeg-install/lib/* ${OBJLIB}
cd ..
