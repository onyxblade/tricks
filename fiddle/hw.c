#include <stdio.h>

int hw(char* str,int n){
	printf("%s\n", str);
	return n;
}

typedef struct{
	char* string;
	int integer;
} Test;

void hw_s(Test *t){
	t->integer = 1000;
	t->string[0] = 'r';
}

// compiled by
// gcc hw.c --share -o hw.so