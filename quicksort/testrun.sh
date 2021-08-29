#!/bin/bash

../tests/generate.sh
mv input.in quicksort.in

# set the stack size of the shell session for successful execution
ulimit -s 4000000000

g++ -Wall -O3 quicksort.C quicksort.S -o quicksort.out
./quicksort.out
rm quicksort.in quicksort.out
