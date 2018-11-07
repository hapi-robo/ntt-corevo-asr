project(testDriver)

cmake_minimum_required(VERSION 2.8)

set(CMAKE_CXX_FLAGS "--std=c++11")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -pg -DDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE "-O2 -Wall")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

include_directories(./ ../../include/corevo/ ../../include/corevo/impl/ ../../include/picojson/ /home/boost_1_59_0/)
link_directories(/home/corevo_ASR_SDK_for_Linux_v1.0.1.0/libs/x86_64)

#set(CMAKE_BUILD_TYPE Debug)
set(CMAKE_BUILD_TYPE Release)

add_executable(AsrTestDriver Main.cpp vrg_client.cpp AudioRecorderExternalInput.cpp)
target_link_libraries(AsrTestDriver corevo vrgclient pthread)
