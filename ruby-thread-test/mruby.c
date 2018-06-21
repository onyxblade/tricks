#include <stdio.h>
#include <mruby.h>
#include <mruby/compile.h>
#include <pthread.h>
#include <unistd.h>

mrb_state *mrb;
pthread_mutex_t mutex;

void *thread1 () {
	for (int i = 0; i < 10000; ++i) {
		pthread_mutex_lock(&mutex);
		mrb_load_string(mrb, "p 123");
		pthread_mutex_unlock(&mutex);
	}
}

void *thread2 () {
	for (int i = 0; i < 10000; ++i) {
		pthread_mutex_lock(&mutex);
		mrb_load_string(mrb, "p 456");
		pthread_mutex_unlock(&mutex);
	}
}
// gcc -I/home/cichol/mruby/include mruby.c /home/cichol/mruby/build/host/lib/libmruby.a -lpthread -lm -o mruby
int main () {
	mrb = mrb_open();

	pthread_mutex_init(&mutex, NULL);

	pthread_t id1, id2;
	pthread_create(&id1, NULL, (void*)thread1, NULL);
	pthread_create(&id2, NULL, (void*)thread2, NULL);

	sleep(5);

	printf("finished\n");
	return 0;
}
