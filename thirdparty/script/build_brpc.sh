#########################################################################
# File Name: build_brpc.sh
# Author: yunfeizhao
# mail: yunfeizhao@deepglint.com
# Created Time: 2018年05月14日 星期一 17时34分22秒
#########################################################################
#!/bin/bash

BRPCDIR=../brpc
OUTPUT=../output/

if [ ! -d ${OUTPUT} ];then
	mkdir -p ${OUTPUT}
fi

cd ${BRPCDIR}
rm -rf build
mkdir build
cd build
cmake .. && make -j8
cd ..
cp -rf build/output/* ${OUTPUT}
