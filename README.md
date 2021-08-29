# High-Speed Sorting for Generic Applications
Implementation of quicksort and heapsort in AArch64 utilizing branching table
for median of 3 quicksort pivot selection. Insertion sort is called when the
size of the sub-lists is <= 20. Heapsort utilizes linear build heap for optimal
run-time. The C++ code for the quicksort and heapsort has also been updated with
the same optimization, but is still much slower.

When compiling with optimizations the C++ insertion sort is substantially faster.
For example, with random lists of size 100,000 with random elements ranging from
[0, 100,000), the insertion sort with median of 3 quicksort ~5 seconds while the
arm implementation of the same code with the branching table for the median of 3
and the insertion sort in Arm the average is ~0.013 seconds. With compiler
optimizations the time for the C++ implementation is ~0.88 seconds, while the
Arm implementation is ~0.013. The Arm implementation does not improve while the
C++ code is substantially optimized. Overall the Arm implementation is orders of
magnitude faster when handling lists of any enormity.

## Quicksort Sample Run
```
Before quicksort_median_3
After quicksort_median_3
List is in order
median 3 took     0.016051 seconds.
Before quicksort_arm
After quicksort_arm
List is in order
arm median 3 took 0.015274 seconds.
Before quicksort_left
After quicksort_left
List is in order
left took         0.014303 seconds.
-----------------------------------------
Try quicksort on sorted list
Before quicksort_arm on sorted list
After quicksort_arm on sorted list
List is in order
arm median 3 took 0.00343399 seconds.
Before quicksort_left on sorted list
After quicksort_left on sorted list
List is in order
left took         9.08972 seconds.
Done with quicksort
```
