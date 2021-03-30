        .equ    N_REPEAT, 10000

////////////////////////////////////////////////////////////////////////////////

        .global swap_int
        .type   swap_int, %function // void swap_int(int &i, int &j)
swap_int:
        ldr     w2, [x0]            // i
        ldr     w3, [x1]            // j

        str     w3, [x0]            // i = j
        str     w2, [x1]            // j = i

        ret
        .size   swap_int, (.  - swap_int)

////////////////////////////////////////////////////////////////////////////////

        .global heap_insert_arm
        .type   heap_insert_arm, %function // void heap_insert_arm(int a[], int &n, int val)
heap_insert_arm:
        stp     x29, x30, [sp, -48]!
        stp     x19, x20, [sp, 16]
        str     x21, [sp, 32]

        mov     x19, x0             // r19 = a[]
        ldr     w20, [x1]           // r20 = n

        add     w20, w20, 1
        str     w20, [x1]           // n++

        lsl     w3, w20, 2
        str     w2, [x19, x3]       // a[n] = val

        cmp     w20, 1              // if( n == 1 ) then return
        beq     heap_insert_arm_exit//  return

loop_percolate: // n effectively becomes i
        lsr     w21, w20, 1         // parent = i / 2
        lsl     w20, w20, 2
        lsl     w21, w21, 2
        ldr     w0, [x19, x20]      // a[i]
        ldr     w1, [x19, x21]      // a[parent]

        cmp     w0, w1              // if( a[i] <= a[parent] )
        ble     heap_insert_arm_exit//  return

        add     x0, x19, x20        // &a[i]
        add     x1, x19, x21        // &a[parent]
        bl      swap_int            // swap_int( a[i], a[parent] )

        lsr     w20, w21, 2         // i = parent

        cmp     w20, 1              // post-test
        bgt     loop_percolate      // while( i > 1 )

heap_insert_arm_exit:
        ldr     x21, [sp, 32]
        ldp     x19, x20, [sp, 16]
        ldp     x29, x30, [sp], 48
        ret
        .size   heap_insert_arm, (.  - heap_insert_arm)

////////////////////////////////////////////////////////////////////////////////

        .global heap_delete_arm
        .type   heap_delete_arm, %function // int heap_delete_arm(int a[], int &n)
heap_delete_arm:
        stp     x29, x30, [sp, -16]!
        stp     x19, x20, [sp, -16]!
        stp     x21, x22, [sp, -16]!

        mov     x19, x0             // r19 = a[]
        mov     x20, x1             // r20 = &n
        ldr     w21, [x1]           // r21 = n
        ldr     w22, [x19, 4]       // r22 = a[1] <- return value

        cmp     w21, 1              // if( n == 1 )
        beq     heap_delete_arm_exit//  return

        // a[1] = a[n]
        lsl     w0, w21, 2
        ldr     w0, [x19, x0]
        str     w0, [x19, 4]

        sub     w21, w21, 1
        str     w21, [x20]          // n--

        cmp     w21, 1              // if( n == 1 )
        beq     heap_delete_arm_exit//  return

        mov     w29, 1              // i = 1
loop:
        lsl     w6, w29, 1          // left_child = 2 * i
        mov     w7, w6              // big_child = left_child
        add     w8, w6, 1           // right_child = left_child + 1

        cmp     w8, w21             // if( right_child <= n )
        bgt     skip_cmp_right_and_left_children//  compare failed

        lsl     w2, w8, 2
        lsl     w0, w6, 2
        ldr     w2, [x19, x2]       // a[right_child]
        ldr     w0, [x19, x0]       // a[left_child]
        cmp     w2, w0              // if( a[right_child] > a[left_child] )
        ble     skip_cmp_right_and_left_children//  compare failed

        mov     w7, w8              // big_child = right_child

skip_cmp_right_and_left_children:
        lsl     w3, w29, 2
        lsl     w4, w7, 2
        ldr     w0, [x19, x3]       // a[i]
        ldr     w1, [x19, x4]       // a[big_child]
        cmp     w0, w1              // if( a[i] >= a[big_child] )
        bge     heap_delete_arm_exit//  return

        mov     w29, w7             // i = big_child

        add     x0, x19, x3
        add     x1, x19, x4
        bl      swap_int            // swap_int( a[*i], a[big_child] ) -> prev_i value

        lsl     w0, w29, 1
        cmp     w0, w21             // while( 2 * i < n )
        blt     loop

heap_delete_arm_exit:
        mov     w0, w22             // return result
        ldp     x21, x22, [sp], 16
        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        ret
        .size   heap_delete_arm, (.  - heap_delete_arm)

////////////////////////////////////////////////////////////////////////////////
