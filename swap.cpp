#include <iostream>

using namespace std;

template <class T>
bool swap(T *x, T *y){
	char *cx = (char*) x, *cy = (char*) y;
	for(size_t i=0;i<sizeof *x;++i){
		*cx ^= *cy;
		*cy ^= *cx;
		*cx ^= *cy;
		++cx;
		++cy;
	}
	return true;
}

int main(){
	double x = 1.302, y = 3.093;
	long a = 123456, b = 654321;
	swap(&x, &y);
	swap(&a, &b);
	cout<<x<<endl<<y<<endl;
	cout<<a<<endl<<b<<endl;
	return 0;
}