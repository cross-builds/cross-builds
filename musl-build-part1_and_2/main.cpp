#include <features.h>
#ifndef __GLIBC__
    #define __MUSL__ 
#endif

#include <iostream>

int main() {
#ifdef __MUSL__
   std::cout << "Hello MUSL C++!\n";
#else 
   std::cout <<"Hello GNU C++!\n";
#endif
    return 0;
}