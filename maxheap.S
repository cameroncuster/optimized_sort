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

        .global heapify
        .type   heapify, %function // void heapify( int a[], int n, int i )
heapify:
        stp     x29, x30, [sp, -16]!
        stp     x19, x20, [sp, -16]!

        mov     x19, x0             // r19 = a[]
        mov     w20, w1             // r20 = n
        mov     w29, w2             // r29 = i

        mov     w3, w29             // smallest = i
        lsl     w2, w2, 1           // i *= 2
        add     w4, w2, 1           // l = 2 * i + 1
        add     w5, w2, 2           // r = 2 * i + 2

        cmp     w4, w20             // if( l >= n )
        bge     left_child_out_of_bounds//  goto left_child_out_of_bounds
        ldr     w6, [x19, x4, lsl 2]// a[l]
        ldr     w7, [x19, x3, lsl 2]// a[smallest]
        cmp     w6, w7              // if( a[l] >= a[smallest] )
        bge     left_child_out_of_bounds//  goto left_child_out_of_bounds
        mov     w3, w4              // smallest = l

left_child_out_of_bounds:
        cmp     w5, w20             // if( r >= n )
        bge     right_child_out_of_bounds// goto right_child_out_of_bounds
        ldr     w6, [x19, x4, lsl 2]// a[r]
        ldr     w7, [x19, x3, lsl 2]// a[smallest]
        cmp     w6, w7              // if( a[r] >= a[smallest] )
        bge right_child_out_of_bounds// goto right_child_out_of_bounds
        mov     w3, w5              // smallest = r

right_child_out_of_bounds:
        cmp     w3, w29             // if( smallest != i )
        beq     heapify_exit        //  return
        lsl     w29, w29, 2
        add     x0, x19, x29
        mov     w29, w3
        lsl     w3, w3, 2
        add     x1, x19, x3
        bl      swap_int            // swap_int( a[i], a[smallest] )

        mov     x0, x19
        mov     w1, w20
        mov     w2, w29
        bl      heapify             // heapify( a[], n, smallest )

heapify_exit:
        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        ret
        .size   heapify, (. - heapify)

////////////////////////////////////////////////////////////////////////////////

        .global buildHeap
        .type   buildHeap, %function // void buildHeap( int a[], int n )
buildHeap:
        stp     x29, x30, [sp, -16]!
        stp     x19, x20, [sp, -16]!

        mov     x19, x0             // r19 = a[]
        mov     w20, w1             // r20 = n
        mov     w29, w20            // i = n

buildHeap_Heapify_Values:
        mov     x0, x19
        mov     w1, w20
        mov     w2, w29
        bl      heapify             // heapify( a[], n, i )
        sub     w29, w29, 1
        cmp     w29, 0
        bge     buildHeap_Heapify_Values   // for( i = n; i >= 0; i-- )

        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        ret
        .size   buildHeap, (. - buildHeap)

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

        lsl     w21, w21, 2

        mov     w29, 4              // i = 1
loop:
        lsl     w6, w29, 1          // left_child = 2 * i
        mov     w7, w6              // big_child = left_child
        add     w8, w6, 4           // right_child = left_child + 1

        cmp     w8, w21             // if( right_child <= n )
        bgt     skip_cmp_right_and_left_children//  compare failed

        ldr     w2, [x19, x8]       // a[right_child]
        ldr     w0, [x19, x6]       // a[left_child]
        cmp     w2, w0              // if( a[right_child] > a[left_child] )
        ble     skip_cmp_right_and_left_children//  compare failed

        mov     w7, w8              // big_child = right_child

skip_cmp_right_and_left_children:
        ldr     w0, [x19, x29]      // a[i]
        ldr     w1, [x19, x7]       // a[big_child]
        cmp     w0, w1              // if( a[i] >= a[big_child] )
        bge     heap_delete_arm_exit//  return

        add     x0, x19, x29
        add     x1, x19, x7
        mov     w29, w7             // i = big_child
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
