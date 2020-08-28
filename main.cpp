#include <iostream>

#include "etcd/Client.hpp"


int main() {
    std::cout << "Hello, World!" << std::endl;

    etcd::Client etcd("http://127.0.0.1:2379");


    etcd::Response resp = etcd.add("/test/key1", "42").get();

    std::cout << "Error code: " << resp.error_code() << std::endl;
    std::cout << "Is_OK: " << resp.is_ok() << std::endl;

//    etcd::Response resp = etcd.get("/Common/Log");

    return 0;
}
