#include <stdio.h>

int hw(int n){
	printf("Hello World.\n");
	printf("parameter: %d\n", n);
	return 0;
}

// compiled by
// gcc hw.c -shared -o hw.so