cmake_minimum_required(VERSION 3.10)

project(hello-cpp)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(hello-cpp src/main.cpp)

install(TARGETS hello-cpp DESTINATION bin)
