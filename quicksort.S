        .equ    INSERTION_SORT_SIZE, 20
        .set    USE_INSERTION_SORT, 1       // behaves as a boolean #define C++ directive

////////////////////////////////////////////////////////////////////////////////
//  swap two 8 byte elements given their addresses                            //
////////////////////////////////////////////////////////////////////////////////

        .global swap_long
        .type   swap_long, %function    // void swap_long(long &i, long &j)
swap_long:
        ldr     x2, [x0]                // i
        ldr     x3, [x1]                // j

        str     x3, [x0]                // i = j
        str     x2, [x1]                // j = i

        ret
        .size   swap_long, (.  - swap_long)

////////////////////////////////////////////////////////////////////////////////
//  evaluate the median of 3 for quicksort utilizing a branching table        //
////////////////////////////////////////////////////////////////////////////////

        .global median_of_3_arm
        .type   median_of_3_arm, %function // median_of_3_arm(long a[], int left, int right)
median_of_3_arm:
        stp     x29, x30, [sp, -16]!

        add     w3, w1, w2
        lsr     w3, w3, 1               // mid ( r3 ) = ( left + right ) / 2

        lsl     w1, w1, 3               // left
        lsl     w2, w2, 3               // right
        lsl     w3, w3, 3               // mid

        ldr     x4, [x0, x1]            // a_left = a[left]     -> x
        ldr     x5, [x0, x2]            // a_right = a[right]   -> z
        ldr     x6, [x0, x3]            // a_mid = a[mid]       -> y

        add     x1, x1, x0              // &a[left]

        mov     w7, 0                   // Bit value: 000

cmp_x_to_y:
        cmp     x4, x6                  // if( x >= y )
        blt     cmp_x_to_z
        add     w7, w7, 16              // Current bit value: xxxx xxxx xxx ( 100 ) 00

cmp_x_to_z:
        cmp     x4, x5                  // if( x >= z )
        blt     cmp_y_to_z
        add     w7, w7, 8               // Current bit value: xxxx xxxx xxx ( x10 ) 00

cmp_y_to_z:
        cmp     x6, x5                  // if( y >= z )
        blt     position_branch_table
        add     w7, w7, 4               // Current bit value: xxxx xxxx xxx ( xx1 ) 00

position_branch_table:
        ldr     x5, =branch_table
        add     x7, x7, x5
        br      x7

branch_table:
        b       y_median
        b       z_median
        b       y_median
        b       x_median
        b       x_median
        b       y_median
        b       z_median
        b       y_median


y_median:
        add     x0, x3, x0              // &a[mid]
        bl      swap_long
        b       median_of_3_arm_exit

z_median:
        add     x0, x2, x0              // &a[right]
        bl      swap_long

x_median:
median_of_3_arm_exit:
        ldp     x29, x30, [sp], 16
        ret
        .size   median_of_3_arm, (.  - median_of_3_arm)

////////////////////////////////////////////////////////////////////////////////
//  insertion sort implementation                                             //
////////////////////////////////////////////////////////////////////////////////

        .global insertion_sort_arm
        .type   insertion_sort_arm, %function // void insertion_sort_arm( long a[], int left, int right )
insertion_sort_arm:
        stp     x29, x30, [sp, -16]!

        mov     w3, w1                  // i = left

loop_over_keys:
        cmp     w3, w2                  // while( i <= right )
        bgt     exit_insertion_sort
        ldr     x4, [x0, x3, lsl 3]     // key = a[i]
        sub     w5, w3, 1               // j = i - 1

insertion_loop:
        cmp     w5, w1
        blt     end_insertion_loop
        ldr     x6, [x0, x5, lsl 3]
        cmp     x6, x4
        ble     end_insertion_loop      // while( j >= left && a[j] > key )
        add     w7, w5, 1               // r7 = j + 1
        str     x6, [x0, x7, lsl 3]     // a[j + 1] = a[j]
        sub     w5, w5, 1               // j--
        b       insertion_loop


end_insertion_loop:
        add     w5, w5, 1               // j += 1
        str     x4, [x0, x5, lsl 3]     // a[j + 1] = key
        add     w3, w3, 1               // i++
        b       loop_over_keys

exit_insertion_sort:
        ldp     x29, x30, [sp], 16
        ret
        .size   insertion_sort_arm, (. - insertion_sort_arm)


////////////////////////////////////////////////////////////////////////////////
//  quicksort implementation utilizing median of 3 branching table and        //
//  insertion sort with lists <= INSERTION_SORT_SIZE                          //
////////////////////////////////////////////////////////////////////////////////

        .global quicksort_arm
        .type   quicksort_arm, %function // void quicksort_arm(long a[], int left, int right)
quicksort_arm:
        stp     x29, x30, [sp, -16]!
        stp     x19, x20, [sp, -16]!
        stp     x21, x22, [sp, -16]!
        stp     x23, x24, [sp, -16]!

        .if     USE_INSERTION_SORT

        sub     w3, w2, w1              // r3 = right - left
        cmp     w3, INSERTION_SORT_SIZE // if( r3 <= 20 )
        bgt     call_quicksort
        bl      insertion_sort_arm      // insertion_sort_arm( a, left, right )
        b       quicksort_arm_exit

        .endif

call_quicksort:
        mov     x19, x0                 // r19 = a
        mov     w20, w1                 // r20 = left
        mov     w21, w2                 // r21 = right

        cmp     w20, w21                // if( left >= right )
        bge     quicksort_arm_exit      //  return

        mov     w22, w20                // i = left
        add     w23, w21, 1             // j = right + 1

        bl      median_of_3_arm
        lsl     w0, w22, 3
        ldr     x24, [x19, x0]          // pivot = a[left]

not_crossed:
i_to_pivot:
        add     w22, w22, 1             // i++
        lsl     w0, w22, 3
        ldr     x0, [x19, x0]
        cmp     x0, x24                 // while( a[i] < pivot )
        blt     i_to_pivot

j_to_pivot:
        sub     w23, w23, 1             // j--
        lsl     w0, w23, 3
        ldr     x0, [x19, x0]
        cmp     x0, x24                 // while( a[j] < pivot )
        bgt     j_to_pivot

        cmp     w22, w23                // if( i < j )
        bge     end_do                  //  swap( a[i], a[j] )
        lsl     w0, w22, 3
        lsl     w1, w23, 3
        add     x0, x19, x0             // &a[i]
        add     x1, x19, x1             // &a[j]
        bl      swap_long               // swap( a[i], a[j] )

end_do:
        cmp     w22, w23                // while( i <= j )
        ble     not_crossed

        lsl     w0, w20, 3
        lsl     w1, w23, 3
        add     x0, x19, x0             // &a[left]
        add     x1, x19, x1             // &a[j]
        bl      swap_long               // swap( a[left], a[j] )

        mov     x0, x19
        mov     w1, w20
        sub     w2, w23, 1
        bl      quicksort_arm           // quicksort_arm( a, left, j - 1 )

        mov     x0, x19
        add     w1, w23, 1
        mov     w2, w21
        bl      quicksort_arm           // quicksort_arm( a, j + 1, right )

quicksort_arm_exit:
        ldp     x23, x24, [sp], 16
        ldp     x21, x22, [sp], 16
        ldp     x19, x20, [sp], 16
        ldp     x29, x30, [sp], 16
        ret
        .size   quicksort_arm, (.  - quicksort_arm)
