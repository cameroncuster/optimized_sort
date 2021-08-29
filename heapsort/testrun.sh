#!/bin/bash

../tests/generate.sh
mv input.in heaptest.in

# set the stack size of the shell session for successful execution
ulimit -s 4000000000

g++ -Wall -O3 maxheap.C maxheap.S -o heapsort.out
./heapsort.out
rm heaptest.in heapsort.out
