		.equ	N_REPEAT, 10000

////////////////////////////////////////////////////////////////////////////////

		.global	swap_int
		.type	swap_int, %function // void swap_int(int &i, int &j)
swap_int:
		ldr		w2, [x0]			// i
		ldr		w3, [x1]			// j

		str		w3, [x0]			// i = j
		str		w2, [x1]			// j = i

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

		add		w20, w20, 1
		str		w20, [x1]			// n++

		lsl		w3, w20, 2
		str		w2, [x19, x3]		// a[n] = val

		cmp		w20, 1				// if( n == 1 ) then return
		beq		heap_insert_arm_exit//	return

loop_percolate:	// n effectively becomes i
		lsr		w21, w20, 2			// parent = i / 2
		lsl		w20, w20, 2
		lsl		w21, w21, 2
		ldr		w0, [x19, x20]		// a[i]
		ldr		w1, [x19, x21]		// a[parent]

		cmp		w0, w1				// if( a[i] <= a[parent] )
		ble		heap_insert_arm_exit//	return

		add		x0, x19, x20		// &a[i]
		add		x1, x19, x21		// &a[parent]
		bl		swap_int			// swap_int( a[i], a[parent] )

		lsr		w20, w20, 2
		lsr		w21, w21, 2
		mov		w20, w21			// i = parent

		cmp		w20, 1				// post-test
		bgt		loop_percolate		// while( i > 1 )
/*
		mov		w21, w20			// parent = i / 2
		lsl		w20, w20, 2
		ldr		w0, [x19, x20]		// a[i]
		ldr		w1, [x19, x21]		// a[parent]

		cmp		w0, w1				// if( a[i] <= a[parent] )
		ble		heap_insert_arm_exit//	return

		add		x0, x19, x20		// &a[i]
		add		x1, x19, x21		// &a[parent]
		bl		swap_int			// swap_int( a[i], a[parent] )

		lsr		w20, w21, 2			// i = parent

		cmp		w20, 4				// post-test
		bgt		loop_percolate		// while( i > 4 )
		*/

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
		stp		x29, x30, [sp, -16]!
		stp		x19, x20, [sp, -16]!
		stp		x21, x22, [sp, -16]!
		stp		x23, x24, [sp, -16]!

		mov		x22, x1				// store &n

		mov		x19, x0				// r19 = a[]
		ldr		w20, [x1]			// r20 = n
		mov		w23, w20			// r23 = n

		ldr		w21, [x19, 4]		// result ( r21 ) = a[1]

		cmp		w20, 1				// if( n == 1 )
		beq		heap_delete_arm_exit//	return

		// a[1] = a[n]
		lsl		w2, w20, 2
		ldr		w0, [x19, x2]
		str		w0, [x19, 4]

		cmp		w20, 2				// if( n == 2 )
		beq		heap_delete_arm_exit//	return

		lsl		w20, w20, 2			// quick shift of n for word size	*** FIX ***
		mov		w29, 4				// i = 1
loop:
		lsl		w0, w20, 2			// left_child = 2 * i
		add		w1, w0, 4			// right_child = left_child + 1
		mov		w2, w0				// big_child = left_child

		cmp		w1, w20				// if( right_child < n )
		bge		heap_delete_arm_exit//	return

		ldr		w3, [x19, x1]		// a[right_child]
		ldr		w4, [x19, x0]		// a[left_child]
		cmp		w3, w4				// if( a[right_child] > a[left_child] )
		ble		heap_delete_arm_exit//	return

		mov		w2, w1				// big_child = right_child

skip_cmp_right_and_left_children:
		ldr		w0, [x19, x29]		// a[i]
		ldr		w1, [x19, x1]		// a[big_child]
		cmp		w0, w1				// if( a[i] >= a[big_child] )
		bge		heap_delete_arm_exit//	return

		mov		w29, w2				// i = big_child

		bl		swap_int			// swap_int( a[*i], a[big_child] ) -> prev_i value

		lsl		w0, w29, 1			// 2 * i
		cmp		w0, w20				// while( 2 * i < n )
		bge		loop

heap_delete_arm_exit:
		sub		w23, w23, 1
		str		w23, [x22]			// n--
		mov		w0, w21				// return result

		ldp		x23, x24, [sp], 16
		ldp		x21, x22, [sp], 16
		ldp		x19, x20, [sp], 16
		ldp		x29, x30, [sp], 16
		ret
		.size	heap_delete_arm, (.  - heap_delete_arm)

////////////////////////////////////////////////////////////////////////////////
