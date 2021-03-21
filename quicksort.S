		.equ	MAX_N, 1000000

////////////////////////////////////////////////////////////////////////////////

		.global	swap_long
		.type	swap_long, %function // void swap_long(long &i, long &j)
swap_long:
		stp		x29, x30, [sp, -16]!

		ldr		x2, [x0]			// i
		ldr		x3, [x1]			// j

		str		x3, [x0]			// i = j
		str		x2, [x1]			// j = i

		ldp		x29, x30, [sp], 16
		ret
		.size	swap_long, (.  - swap_long)

////////////////////////////////////////////////////////////////////////////////

		.global	median_of_3_arm
		.type	median_of_3_arm, %function // median_of_3_arm(long a[], int left, int right)
median_of_3_arm:
		stp		x29, x30, [sp, -16]!

		add		w3, w1, w2
		lsr		w3, w3, 1				// mid ( r3 ) = ( left + right ) / 2

		lsl		w1, w1, 3				// left
		lsl		w2, w2, 3				// right
		lsl		w3, w3, 3				// mid

		ldr		x4, [x0, x1]			// a_left = a[left]		-> x
		ldr		x5, [x0, x2]			// a_right = a[right]	-> z
		ldr		x6, [x0, x3]			// a_mid = a[mid]		-> y

		mov		w7, 0					// Bit value: 000

cmp_x_to_y:
		cmp		x4, x6					// if( x >= y )
		blt		cmp_x_to_z
		add		w7, w7, 16				// Current bit value: xxxx xxxx xxx ( 100 ) 00

cmp_x_to_z:
		cmp		x4, x5					// if( x >= z )
		blt		cmp_y_to_z
		add		w7, w7, 8				// Current bit value: xxxx xxxx xxx ( x10 ) 00

cmp_y_to_z:
		cmp		x6, x5					// if( y >= z )
		blt		position_branch_table
		add		w0, w0, 4				// Current bit value: xxxx xxxx xxx ( xx1 ) 00

position_branch_table:
		ldr		x7, =branch_table
		add		x7, x7, x0
		br		x7

branch_table:
		b		y_median
		b		z_median
		b		y_median
		b		x_median
		b		x_median
		b		y_median
		b		z_median
		b		y_median

		add		x1, x4, x0				// &a[left]

y_median:
		add		x0, x6, x0				// &a[mid]
		bl		swap_long
		b		median_of_3_arm_exit

z_median:
		add		x0, x5, x0				// &a[right]
		bl		swap_long

x_median:
median_of_3_arm_exit:
		ldp		x29, x30, [sp], 16
		ret
		.size	median_of_3_arm, (.  - median_of_3_arm)

////////////////////////////////////////////////////////////////////////////////

		.global	quicksort_arm
		.type	quicksort_arm, %function // void quicksort_arm(long a[], int left, int right)
quicksort_arm:
		stp		x29, x30, [sp, -16]!
		stp		x19, x20, [sp, -16]!
		stp		x21, x22, [sp, -16]!
		stp		x23, x24, [sp, -16]!

		mov		x19, x0					// r19 = a[]
		mov		w20, x1					// r20 = left
		mov		w21, x2					// r21 = right

		cmp		w1, w2					// if( left >= right )
		bge		quicksort_arm_exit		//	return

		// cont.


quicksort_arm_exit:
		ldp		x23, x24, [sp], 16
		ldp		x21, x22, [sp], 16
		ldp		x19, x20, [sp], 16
		ldp		x29, x30, [sp], 16
		ret
		.size	quicksort_arm, (.  - quicksort_arm)
