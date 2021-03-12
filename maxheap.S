		.equ	N_REPEAT, 10000



		.global	swap_int
		.type	swap_int, %function // void swap_int(int &i, int &j)
swap_int:
		stp		x29, x30, [sp, #-16]!

		mov		w2, w1				// temp = j
		mov		w1, w0				// j = i
		mov		w0, w2				// i = j

		ldp		x29, x30, [sp], #16
		ret
		.size	swap_int, (.  - swap_int)



		.global	heap_insert_arm
		.type	heap_insert_arm, %function // void heap_insert_arm(int a[], int &n, int val)
heap_insert_arm:
		stp		x29, x30, [sp, #-48]!
		stp		x19, x20, [sp, #16]
		str		x21, [sp, #32]

		mov		x19, x0				// x19 = a[]
		ldr		x20, [x1]				// x20 = n

		mov		w3, #1
		add		w20, w20, w3, lsl #2

		str		x2, [x19, x20]		// a[n] = val

		cmp		w20, #1				// if( n == 1 )
		beq		heap_insert_arm_exit//	return;

loop_percolate:	// n effectively becomes i and is pre-shifted to account for size of word
		mov		w21, w20, lsr #1		// parent = i / 2 ***** VERIFY *****
		ldr		x4, [x19, x20]		// a[i]
		ldr		x5, [x19, x21]		// a[parent]

		cmp		x4, x5				// if( a[i] <= a[parent] )
		ble		heap_insert_arm_exit//	return

		add		x0, x19, x20		// &a[i]
		add		x1, x19, x21		// &a[parent]
		bl		swap_int			// swap( a[i], a[parent] )

		mov		w20, w21			// i = parent

		cmp		w20, #1				// post-test
		bgt		loop_percolate		// while( i > 1 )

heap_insert_arm_exit:
		ldr		x21, [sp, #32]
		ldp		x19, x20, [sp, #16]
		ldp		x29, x30, [sp], #48
		ret
		.size	heap_insert_arm, (.  - heap_insert_arm)



		.global	heap_delete_arm
		.type	heap_delete_arm, %function // int heap_delete_arm(int a[], int &n)
heap_delete_arm:
		stp		x29, x30, [sp, #-16]!

heap_delete_arm_exit:
		ldp		x29, x30, [sp], #16
		ret
		.size	heap_delete_arm, (.  - heap_delete_arm)
