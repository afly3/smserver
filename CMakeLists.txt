cmake_minimum_required(VERSION 3.5)
project(smserver)

set(CMAKE_CXX_STANDARD 11)
#set(BRPC_ENABLE_CPU_PROFILER 1) # 开启可以perf，但是未分析对性能的影响，发布时关闭

IF(CMAKE_BUILD_TYPE)
ELSE()
    SET(CMAKE_BUILD_TYPE "Debug")
ENDIF()

option(BUILD_SMSERVER_TOOLS "Build vse tools" ON)
option(BUILD_SMSERVER_TEST "Build vse tests" ON)

## set version
#file(STRINGS ${CMAKE_CURRENT_SOURCE_DIR}/VERSION VERSION_CONTENT)


# flag
#SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64 -fopenmp -Wl,--no-as-needed -pthread -lm -ldl -D VSE_VERSION=${VERSION_CONTENT} -D DGJSON -D BRPC_ENABLE_CPU_PROFILER")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64 -fopenmp -Wl,--no-as-needed -pthread -lm -ldl -D VSE_VERSION=${VERSION_CONTENT} -D DGJSON ")
SET(CMAKE_CXX_FLAGS_DEBUG " $ENV{CXXFLAGS}   -std=c++11  -DDEBUG -g -O0 -ggdb3 -w ")
SET(CMAKE_CXX_FLAGS_RELEASE " $ENV{CXXFLAGS} -std=c++11  -DNDEBUG -g -O3 -w ")

find_library(PROTOC_LIB NAMES protoc)
if(NOT PROTOC_LIB)
    message(FATAL_ERROR "Fail to find protoc lib")
endif()
include(FindThreads)
set(PROTOBUF_PROTOC_EXECUTABLE protoc)

file(GLOB CONF_PROTOS "src/proto/*.proto")
foreach(PROTO ${CONF_PROTOS})
    message("proto file: ${PROTO}")
    execute_process(
            COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} --cpp_out=./ --proto_path=${CMAKE_CURRENT_SOURCE_DIR}/src/proto ${PROTO}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/proto
    )
endforeach()

execute_process(
        COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} --cpp_out=./  --grpc_out=./ --plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin --proto_path=${CMAKE_CURRENT_SOURCE_DIR}/src/proto ${CMAKE_CURRENT_SOURCE_DIR}/src/proto/arcee.proto
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/src/proto
)

# link output
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/output/include)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/thirdparty/output/lib)

FILE(GLOB_RECURSE SRC_VSE_FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.c
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.h
        ${CMAKE_CURRENT_SOURCE_DIR}/src/*.hpp
        )


set(DYNAMIC_LIB
        ${PROTOC_LIB}
        protobuf protobuf-lite
        grpc grpc++ grpc++_unsecure
        brpc
        srsrtmp
        avcodec avutil avformat
        b64 uuid sqlite3 curl ssl crypto dl
        gflags glog
        )

add_executable(smserver src/main.cpp ${SRC_VSE_FILES})
message("+++++" ${DYNAMIC_LIB})

#build tools
if(BUILD_VSE_TOOLS)
    add_subdirectory(tools)
endif()

# build tests
if(BUILD_VSE_TEST)
    add_subdirectory(unit_test)
endif()
