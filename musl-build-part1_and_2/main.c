
#include <features.h>
#ifndef __GLIBC__
    #define __MUSL__ 
#endif

#include <stdio.h>
int main() {
#ifdef __MUSL__
   printf("Hello MUSL C!\n");
#else 
   printf("Hello GNU %d C!\n", __GLIBC__);
#endif
   return 0;
}