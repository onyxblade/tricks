#include <stdio.h>
#include <stdlib.h>

#define ALLOC(type, name, leng) type *name = malloc(sizeof(type) * leng);\
								defer(&free_proc, name);

typedef struct DeferNode {
	void (*func)(void *arg);
	void *arg;
	struct DeferNode *next;
} DeferNode;

static DeferNode *DEFER_LIST = NULL;

void defer(void (*func)(void *arg), void* arg) {
	DeferNode *node = malloc(sizeof(DeferNode));
	node->func = func;
	node->arg = arg;
	if (DEFER_LIST) {
		node->next = DEFER_LIST;
	} else {
		node->next = NULL;
	}
	DEFER_LIST = node;
}

void defer_perform() {
	DeferNode *p = DEFER_LIST;
	while (p) {
		p->func(p->arg);
		DeferNode *next = p->next;
		free(p);
		p = next;
	}
}

void free_proc(void *addr) {
	free(addr);
}

int main(){
	int *a = malloc(500);
	defer(&free_proc, a);

	char *b = malloc(1000);
	defer(&free_proc, b);

	ALLOC(int, c, 10);

	defer_perform();
	return 0;
}
