		.equ	N_REPEAT, 10000

////////////////////////////////////////////////////////////////////////////////

		.global	swap_int
		.type	swap_int, %function // void swap_int(int &i, int &j)
swap_int:
		stp		x29, x30, [sp, -16]!

		ldr		w2, [x0]			// i
		ldr		w3, [x1]			// j

		str		w3, [x0]			// i = j
		str		w2, [x1]			// j = i

		ldp		x29, x30, [sp], 16
		ret
		.size	swap_int, (.  - swap_int)

////////////////////////////////////////////////////////////////////////////////

		.global	heap_insert_arm
		.type	heap_insert_arm, %function // void heap_insert_arm(int a[], int &n, int val)
heap_insert_arm:
		stp		x29, x30, [sp, -48]!
		stp		x19, x20, [sp, 16]
		str		x21, [sp, 32]

		mov		x19, x0				// r19 = a[]
		ldr		w20, [x1]			// r20 = n

		add		w20, w20, 1			// n++
		str		w20, [x1]

		cmp		w20, 1				// if( n == 1 ) then retun later

		lsl		w20, w20, 2

		str		w2, [x19, x20]		// a[n] = val

		beq		heap_insert_arm_exit//	return

loop_percolate:	// n effectively becomes i and is pre-shifted to account for size of word
		mov		w21, w20, lsr 1		// parent = i / 2 ***** VERIFY *****
		ldr		w4, [x19, x20]		// a[i]
		ldr		w5, [x19, x21]		// a[parent]

		cmp		w4, w5				// if( a[i] <= a[parent] )
		ble		heap_insert_arm_exit//	return

		add		x0, x19, x20		// &a[i]
		add		x1, x19, x21		// &a[parent]
		bl		swap_int			// swap( a[i], a[parent] )

		mov		w20, w21			// i = parent

		cmp		w20, 1				// post-test
		bgt		loop_percolate		// while( i > 1 )

heap_insert_arm_exit:
		ldr		x21, [sp, 32]
		ldp		x19, x20, [sp, 16]
		ldp		x29, x30, [sp], 48
		ret
		.size	heap_insert_arm, (.  - heap_insert_arm)

////////////////////////////////////////////////////////////////////////////////

		.global	heap_delete_arm
		.type	heap_delete_arm, %function // int heap_delete_arm(int a[], int &n)
heap_delete_arm:
		stp		x29, x30, [sp, -48]!
		stp		x19, x20, [sp, 16]
		str		x21, [sp, 32]

		/*
		mov		x19, x0				// r19 = a[]
		ldr		w20, [x1]			// r20 = n

		ldr		w21, [x19, 4]		// result ( r21 ) = a[1]
		cmp		w20, 1				// if( n == 1 )
		beq		single_element_return//	return result

		// a[1] = a[n]
		lsl		w2, w20, 2
		ldr		w0, [x19, x20]
		str		w0, [x19, 4]

		cmp		w20, 2				// if( n == 2 )
		beq		double_element_return//	return result

		mov		w29, 1				// i = 1
loop:	// do while ( n is one greater )

single_element_return:
		str		xzr, [x1]			//	n = 0
		b		heap_delete_arm_exit// return result

double_element_return:
		mov		w0, 1
		str		x0, [x1]			// n = 1

heap_delete_arm_exit:				// return result & exit
		mov		w0, w21
		*/
		ldr		x21, [sp, 32]
		ldp		x19, x20, [sp, 16]
		ldp		x29, x30, [sp], 48
		ret
		.size	heap_delete_arm, (.  - heap_delete_arm)

////////////////////////////////////////////////////////////////////////////////
