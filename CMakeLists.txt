#cmake_minimum_required(VERSION 3.17)
cmake_minimum_required(VERSION 3.15)

project(cpp_etcd_play)

set(CMAKE_CXX_STANDARD 11)

find_library(CPPREST_LIB NAMES cpprest)
#find_path(CPPREST_INCLUDE_DIR NAMES cpprest/http_client.h)
find_library(ETCD_CLIENT_LIB NAMES etcd-cpp-api)

MESSAGE(STATUS "ETCD_CLIENT_LIB: '${ETCD_CLIENT_LIB}'")

#find_package(Boost REQUIRED COMPONENTS system thread locale random filesystem regex)
find_package(Boost REQUIRED COMPONENTS system )

MESSAGE(STATUS "BOOST LIBS: ${Boost_LIBRARIES}")

add_executable(cpp_etcd_play main.cpp)

#target_link_libraries(cpp_etcd_play ${ETCD_CLIENT_LIB} ${CPPREST_LIB} ${Boost_LIBRARIES} ssl crypto protobuf grpc -pthread)
target_link_libraries(cpp_etcd_play ${ETCD_CLIENT_LIB} ${CPPREST_LIB} ${Boost_LIBRARIES} ssl crypto -pthread )
