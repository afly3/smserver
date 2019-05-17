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

LIBYUVDIR=../librdkafka

if [ ! -d ${OBJIN} ];then
	mkdir -p ${OBJIN}
fi

if [ ! -d ${OBJLIB} ];then
	mkdir -p ${OBJLIB}
fi

cd ${LIBYUVDIR}
./configure --prefix=`pwd`/rdkafka-install
make clean && make -j4 && make install
cp -rf ${LIBYUVDIR}/rdkafka-install/include/* ${OBJIN}
cp -rdf ${LIBYUVDIR}/rdkafka-install/lib/* ${OBJLIB}
cd ..
