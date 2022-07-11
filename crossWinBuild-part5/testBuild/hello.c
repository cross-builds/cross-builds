#include <stdio.h>

int main(int argc, char* argv[]){
    if(sizeof(size_t) == 8)
	    printf("Hello 64 Bit World!\n");
    else if(sizeof(size_t) == 4)
	    printf("Hello 32 Bit World!\n");
    else
         printf("Hello World!\n");
	return 0;
}