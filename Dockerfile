FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install -y curl wget build-essential checkinstall zlib1g-dev ninja-build git libwebsocketpp-dev  libcpprest-dev

#    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib && \

RUN wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz && \
    tar -xf openssl-1.1.1c.tar.gz && \
    cd openssl-1.1.1c && \
    ./config shared zlib && \
    make -j 4 && \
    make install

RUN wget https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.gz

RUN tar xzvf boost_1_73_0.tar.gz && \
    cd boost_1_73_0 && \
    ./bootstrap.sh  --prefix=/usr/local --with-libraries=system,thread,locale,random,chrono,regex,filesystem,atomic,date_time && \
    ./b2 install

RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz && \
    tar xzf cmake-3.15.2.tar.gz && \
    cd cmake-3.15.2 && \
    ./bootstrap && \
    make -j 4 && \
    make install

RUN apt-get install -y automake libtool

RUN git clone https://github.com/protocolbuffers/protobuf.git && \
    cd protobuf && \
    git submodule update --init --recursive && \
    ./autogen.sh && \
    ./configure && \
     make -j 4 && \
     make install && \
     ldconfig

RUN git clone https://github.com/grpc/grpc.git && \
  cd grpc && \
  git submodule update --init && \
  mkdir -p cmake/build && cd cmake/build && \
  cmake  -DCMAKE_BUILD_TYPE=Release -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF -DgRPC_SSL_PROVIDER=package \
    ../.. && \
  make -j 4 && \
  make install

RUN git clone https://github.com/nokia/etcd-cpp-apiv3.git
WORKDIR etcd-cpp-apiv3

RUN sed '$d' CMakeLists.txt > CMakeLists2.txt && mv CMakeLists.txt CMakeLists-old.txt && \
    mv CMakeLists2.txt CMakeLists.txt

RUN ls -l
WORKDIR proto
RUN ls -l
RUN protoc -I . --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` ./rpc.proto
RUN ls -l
RUN protoc -I . --cpp_out=. ./*.proto
RUN ls -l

WORKDIR /etcd-cpp-apiv3

RUN cmake . -DCATCH_INCLUDE_DIR=. && \
    make -j 4 && \
    make install && \
    cp -R v3 /usr/local/include/etcd && \
    cp -R proto /usr/local/include/etcd && \
    cp -R proto /usr/local/include/etcd/v3/include
#    find /usr/local/include/etcd -name KeyValue.hpp -print
#    cp -R v3 /usr/local/include/etcd && \
#    cp -R proto /usr/local/include/etcd && \
#    cp -R proto /usr/local/include/etcd/v3/include/ && \
#    cp /usr/local/include/etcd/*.hpp /usr/local/include/etcd/v3/include && \
#    ln -s /usr/local/include/etcd/v3/proto proto && \
#    ls -l /usr/local/include/etcd/v3/include/ && \
#    cp -R v3 /usr/local/include/etcd && \
#    cp -R proto /usr/local/include/etcd && \
#    cp -R proto /usr/local/include/etcd/v3/include/ && \
#    cp /usr/local/include/etcd/*.hpp /usr/local/include/etcd/v3/include && \
#    ln -s /usr/local/include/etcd/v3/proto proto && \
#    ls -l /usr/local/include/etcd/v3/include/ && \


WORKDIR /

RUN mkdir /sw

COPY CMakeLists.txt main.cpp /sw/

WORKDIR /sw

RUN ln -s /usr/local/include/etcd/v3 /usr/local/include/etcd/v3/include

RUN mkdir build && cd build && \
    cmake .. && \
    make




