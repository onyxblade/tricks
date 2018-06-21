#include <stdio.h>
#include <ruby.h>
#include <pthread.h>
#include <unistd.h>

pthread_mutex_t caller_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t worker_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t call_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t ret_cond = PTHREAD_COND_INITIALIZER;

void perform_task () {
	printf("performing task\n");
}

void create_task () {
	printf("creating task\n");
}

void *worker_thread () {
	ruby_init();
	pthread_mutex_lock(&worker_mutex);
	pthread_mutex_unlock(&caller_mutex);

	while (1) {
		pthread_cond_wait(&call_cond, &worker_mutex);
		perform_task();
		pthread_cond_signal(&ret_cond);
	}
}

void *caller_thread () {
	for (int i = 0; i < 10000; ++i) {
		pthread_mutex_lock(&caller_mutex);
		pthread_mutex_lock(&worker_mutex);
		// create_task();
		pthread_cond_signal(&call_cond);
		pthread_cond_wait(&ret_cond, &worker_mutex);
		// retrieve_data();
		pthread_mutex_unlock(&worker_mutex);
		pthread_mutex_unlock(&caller_mutex);
	}
}

// gcc ruby.c -I/home/cichol/.rbenv/versions/2.5.1/include/ruby-2.5.0/x86_64-linux -I/home/cichol/.rbenv/versions/2.5.1/include/ruby-2.5.0 -L/home/cichol/.rbenv/versions/2.5.1/lib -Wl,--compress-debug-sections=zlib -Wl,-rpath,/home/cichol/.rbenv/versions/2.5.1/lib -lruby -lpthread -lgmp -ldl -lcrypt -lm -o ruby
int main () {
	pthread_mutex_lock(&caller_mutex);

	pthread_t worker_id, caller_id1, caller_id2;
	pthread_create(&worker_id, NULL, (void*)worker_thread, NULL);
	pthread_create(&caller_id1, NULL, (void*)caller_thread, NULL);
	pthread_create(&caller_id2, NULL, (void*)caller_thread, NULL);

	pthread_join(caller_id1, NULL);
	pthread_join(caller_id2, NULL);
	// sleep(3);

	printf("finished\n");
	return 0;
}
