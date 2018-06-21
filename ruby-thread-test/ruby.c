#include <stdio.h>
#include <ruby.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t mutex;

void *thread1 () {
	for (int i = 0; i < 10000; ++i) {
		pthread_mutex_lock(&mutex);
		rb_eval_string("p 123");
		pthread_mutex_unlock(&mutex);
	}
}

void *thread2 () {
	for (int i = 0; i < 10000; ++i) {
		pthread_mutex_lock(&mutex);
		rb_eval_string("p 456");
		pthread_mutex_unlock(&mutex);
	}
}
// gcc ruby.c -I/home/cichol/.rbenv/versions/2.5.1/include/ruby-2.5.0/x86_64-linux -I/home/cichol/.rbenv/versions/2.5.1/include/ruby-2.5.0 -L/home/cichol/.rbenv/versions/2.5.1/lib -Wl,--compress-debug-sections=zlib -Wl,-rpath,/home/cichol/.rbenv/versions/2.5.1/lib -lruby -lpthread -lgmp -ldl -lcrypt -lm -o ruby
int main () {
	ruby_init();

	pthread_mutex_init(&mutex, NULL);

	pthread_t id1, id2;
	pthread_create(&id1, NULL, (void*)thread1, NULL);
	pthread_create(&id2, NULL, (void*)thread2, NULL);

	sleep(5);

	printf("finished\n");
	return 0;
}
