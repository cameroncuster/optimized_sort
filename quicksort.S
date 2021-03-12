		.equ	MAX_N, 1000000



		.global	quicksort_arm
		.type	quicksort_arm, %function // void quicksort_arm(long a[], int left, int right)
quicksort_arm:
		cmp		x0, x1					// if( length <= 1 )
		bge		quicksort_arm_exit		//	return
		stp		x29, x30, [sp, #-48]!
		stp		x19, x20, [sp, #16]
		stp		x21, x22, [sp, #32]

		ldp		x19, x20, [sp, #16]
		ldp		x21, x22, [sp, #32]
		ldp		x29, x30, [sp], #48
quicksort_arm_exit:
		ret
		.size	quicksort_arm, (.  - quicksort_arm)



		.global	median_of_3_arm
		.type	median_of_3_arm, %function // median_of_3_arm(long a[], int left, int right)
median_of_3_arm:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	median_of_3_arm, (.  - median_of_3_arm)
