		.equ	N_REPEAT, 10000

		.global	swap_int
		.type	swap_int, %function // void swap_int(int &i, int &j)
swap_int:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	swap_int, (.  - swap_int)

		.global	heap_insert_arm
		.type	heap_insert_arm, %function // void heap_insert_arm(int a[], int &n, int val)
heap_insert_arm:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	heap_insert_arm, (.  - heap_insert_arm)

		.global	heap_delete_arm
		.type	heap_delete_arm, %function // int heap_delete_arm(int a[], int &n)
heap_delete_arm:
		stp		x29, x30, [sp, #-16]!

		ldp		x29, x30, [sp], #16
		ret
		.size	heap_delete_arm, (.  - heap_delete_arm)
