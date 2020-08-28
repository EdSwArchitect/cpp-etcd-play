cmake_minimum_required(VERSION 3.17)
project(cpp_etcd_play)

set(CMAKE_CXX_STANDARD 14)

find_library(CPPREST_LIB NAMES cpprest)
find_path(CPPREST_INCLUDE_DIR NAMES cpprest/http_client.h)

find_package(Boost REQUIRED COMPONENTS system thread locale random)

add_executable(cpp_etcd_play main.cpp)
target_link_libraries(cpp_etcd_play ${CPPREST_LIB} boost_thread boost_system ssl crypto protobuf grpc++)