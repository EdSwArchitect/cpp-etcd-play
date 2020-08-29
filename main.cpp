#include <iostream>

#include "etcd/Client.hpp"


int main() {
    std::cout << "Hello, World!" << std::endl;

    etcd::Client etcd("http://127.0.0.1:2379");

    etcd::Response resp = etcd.get("/Common/Data").get();

    std::cout << "Error code: " << resp.error_code() << std::endl;
    std::cout << "Is_OK: " << resp.is_ok() << std::endl;
    resp = etcd.get("/Common/Log").get();

    std::cout << "Error code: " << resp.error_code() << std::endl;
    std::cout << "Is_OK: " << resp.is_ok() << std::endl;

    std::cout << "Value: " << resp.value().as_string() << std::endl;

    return 0;
}
