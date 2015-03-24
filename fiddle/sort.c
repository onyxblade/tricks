#include <stdio.h>
#include <stdlib.h>

void merge(int *a, int *aux, int lo, int mid, int hi){
	int i = lo, j = mid+1, k;
	for(k = lo; k <= hi; ++k)	aux[k] = a[k];
	for(k = lo; k <= hi; ++k){
		if(i>mid)	a[k] = aux[j++];
		else if (j>hi)	a[k] = aux[i++];
		else if (aux[j]<aux[i])	a[k] = aux[j++];
		else a[k] = aux[i++];
	}
}

void merge_sort(int *data, int size){
	int *temp = (int*)malloc(sizeof(int) * size);
	int sz, lo, hi;
	for(sz = 1; sz < size; sz *= 2){
		for(lo = 0; lo < size-sz; lo += sz+sz){
			hi = size-1;
			if(lo+sz+sz-1 < hi)	hi = lo+sz+sz-1;
			merge(data, temp, lo, lo+sz-1, hi);
		}
	}
	free(temp);
}
