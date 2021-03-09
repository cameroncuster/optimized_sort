		.equ	MAX_N, 1000000
		.global	quicksort_arm
		.type	quicksort_arm, %function // void quicksort_arm(long a[], int left, int right)
quicksort_arm:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	quicksort_arm, (.  - quicksort_arm)

		.global	median_of_3_arm
		.type	median_of_3_arm, %function // median_of_3_arm(long a[], int left, int right)
median_of_3_arm:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	median_of_3_arm, (.  - median_of_3_arm)
