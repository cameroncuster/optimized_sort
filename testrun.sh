#!/bin/bash

# set the stack size of the shell session for successful execution
ulimit -s 4000000000

read sort
if [ "$sort" != "heapsort" ] && [ "$sort" != "quicksort" ]
then
    exit
fi
g++ generate.C -o generate.out
if [ "$sort" = "heapsort" ]
then
    g++ -Wall maxheap.C maxheap.S -o heap.out
    ./generate.out > heaptest.in
    ./heap.out
    rm heaptest.in heap.out
elif [ "$sort" = "quicksort" ]
then
    g++ -Wall quicksort.C quicksort.S -o quicksort.out
    ./generate.out > quicksort.in
    ./quicksort.out
    rm quicksort.in quicksort.out
fi
rm generate.out
