#!/bin/bash

g++ -Wall -O3 ../tests/generate.C -o generate.out
./generate.out > input.in
rm generate.out
