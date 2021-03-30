////////////////////////////////////////////////////////////////////
//                                                                //
//          Quicksorting With Median of 3 Pivot                   //
//                                                                //
////////////////////////////////////////////////////////////////////

#include <iostream>
#include <fstream>
#include <values.h>  // for MAXINT
using namespace std;

const int  MAX_N =  1000000;
//extern "C" void insertion_sort(long a[], int left, int right);
extern "C" void quicksort_arm(long a[], int left, int right);
extern "C" void median_of_3_arm(long a[], int left, int right);
#define DEBUG false
#define DEBUG_MED false
#define USE_ARM_MEDIAN true

////////////////////////////////////////////////////////////////////

float clock_seconds()
{
    return clock() / (float) CLOCKS_PER_SEC;
}

////////////////////////////////////////////////////////////////////

void print_list(long a[], int n)
{
    int i;

    for(i = 0; i < n; i++)
    {
        cout << " " << a[i];
        if ((i + 1) % 10 == 0)
            cout << endl;
    }
    cout << endl;
}

////////////////////////////////////////////////////////////////////

void check_order(long a[], int n)
{
    int i;
    bool ordered;

    ordered = true;
    for(i = 0; i < n - 1; i++)
    {
        if (a[i] > a[i + 1])
            ordered = false;
    }
    if (ordered)
        cout << "List is in order" << endl;
    else
    {
        cout << "List is NOT in order" << endl;
        print_list(a, n);
        exit(123);
    }
}

////////////////////////////////////////////////////////////////////

void swap(long &x, long &y)
{
    long oldx;
    long oldy;

    oldx = x;
    oldy = y;
    x = oldy;
    y = oldx;
}

////////////////////////////////////////////////////////////////////
//   swap median of first, middle, last to first so               //
//   quicksort function does not need to be changed               //
////////////////////////////////////////////////////////////////////

void median_of_3_to_left(long a[], int left, int right)
{
    int  mid;
    long a_left;
    long a_right;
    long a_mid;

    mid = (left + right) / 2;
    a_left = a[left];
    a_mid = a[mid];
    a_right = a[right];

    // check for left value already median
    if ((a_left >= a_mid) && (a_left <= a_right))
        return;
    if ((a_left <= a_mid) && (a_left >= a_right))
        return;

    // check for middle value is median
    if ((a_mid >= a_left) && (a_mid <= a_right))
    {
        swap(a[mid], a[left]);
        return;
    }
    if ((a_mid <= a_left) && (a_mid >= a_right))
    {
        swap(a[mid], a[left]);
        return;
    }

    // others aren't, so right value must be median
    swap(a[right], a[left]);
}

////////////////////////////////////////////////////////////////////
//  insertion sort for lists with less than 20 elements           //
////////////////////////////////////////////////////////////////////

void insertion_sort( long a[], int left, int right )
{
    int i, j;
    long key;
    for( i = 1; i <= right; i++ )
    {
        key = a[i];
        j = i - 1;
        while( j >= left && a[j] > key )
        {
            a[j + 1] = a[j];
            j = j - 1;
        }
        a[j + 1] = key;
    }
}

////////////////////////////////////////////////////////////////////
//                          quicksort                             //
//    uses original partition algorithm                           //
//    uses median of three as pivot                               //
////////////////////////////////////////////////////////////////////

void quicksort_median_3(long a[], int left, int right)
{
    int  i;
    int  j;
    long pivot;
#if DEBUG_MED
    long check_median;
#endif

    if( right - left <= 20 )
    {
        insertion_sort( a, left, right );
        return;
    }

    if (left < right)
    {
        i = left;
        j = right + 1;
#if DEBUG_MED_2
        cout << "before median call:  " << a[left] << ", " 
            << a[(left+right)/2] << ", " 
            << a[right] << endl;
#endif
#if USE_ARM_MEDIAN
        median_of_3_arm(a, left, right);
#else
        median_of_3_to_left(a, left, right);
#endif
#if DEBUG_MED

        check_median = (a[left] - a[(left+right)/2]) * 
            (a[left] - a[right]);
        if (check_median > 0)
        {
            cout << "Error in median" << endl;
            cout << a[left] << ", " << a[(left+right)/2] << ", " 
                << a[right] << endl;
        }
#endif

        pivot = a[left];

        do
        {
            do
                i++;
            while(a[i] < pivot);

            do
                j--;
            while(a[j] > pivot);

            if (i < j)
                swap(a[i], a[j]);

        } // end do
        while (i <= j);

        swap(a[left], a[j]);
        quicksort_median_3(a, left, j - 1);
        quicksort_median_3(a, j + 1, right);
    }  // end if

} // quick sort

////////////////////////////////////////////////////////////////////

void quicksort_left(long a[], int left, int right)
{
    int  i;
    int  j;
    long pivot;

    if (left < right)
    {
        i = left;
        j = right + 1;
        pivot = a[left];

        do
        {
            do
                i++;
            while(a[i] < pivot);

            do
                j--;
            while(a[j] > pivot);

            if (i < j)
                swap(a[i], a[j]);

        } // end do
        while (i <= j);

        swap(a[left], a[j]);
        quicksort_left(a, left, j - 1);
        quicksort_left(a, j + 1, right);
    }  // end if

} // quick sort

////////////////////////////////////////////////////////////////////

int main(int argc, char *argv[])
{
    long      a[MAX_N + 1]; // quicksort needs an extra spot at end
    long      b[MAX_N + 1]; // copy for sorting again
    long      c[MAX_N + 1]; // copy for sorting again
    int       i;
    ifstream  infile;
    int       n;
    float     t1;
    float     t2;
    float     t3;
    float     t4;

#if DEBUG_MED_2
    a[0] = 10;
    a[1] = 20;
    a[2] = 30;
    cout << "before: " << a[0] << ", " << a[1] << ", " << a[2] << endl;
    median_of_3_arm(a, 0, 2);
    cout << "after:  " << a[0] << ", " << a[1] << ", " << a[2] << endl;

    a[0] = 20;
    a[1] = 10;
    a[2] = 30;
    cout << "before: " << a[0] << ", " << a[1] << ", " << a[2] << endl;
    median_of_3_arm(a, 0, 2);
    cout << "after:  " << a[0] << ", " << a[1] << ", " << a[2] << endl;

    a[0] = 30;
    a[1] = 10;
    a[2] = 20;
    cout << "before: " << a[0] << ", " << a[1] << ", " << a[2] << endl;
    median_of_3_arm(a, 0, 2);
    cout << "after:  " << a[0] << ", " << a[1] << ", " << a[2] << endl;

    return 12;
#endif

    if (argc == 1)
    { 
        infile.open("quicksort.in");
        if (infile . fail())
        {
            cout << "*** FILE quicksort.in NOT FOUND ***" << endl;
            exit(1);
        }
    }
    else
    { 
        infile.open(argv[1]);
        if (infile . fail())
        {
            cout << "*** FILE quicksort.in NOT FOUND ***" << endl;
            exit(1);
        }
    }

    i = 0;
    while(infile >> a[i])
    {
        if (i >= MAX_N)
        {
            cout << "Too many values on file, must be at most " <<
                MAX_N << endl;
            return(1);
        }
        b[i] = a[i];
        c[i] = a[i];
        i++;
    }
    n = i;

    infile.close();

    a[n] = MAXINT;
    b[n] = MAXINT;
    c[n] = MAXINT;

    cout << "Before quicksort_median_3" << endl;
    t1 = clock_seconds();
    quicksort_median_3(a, 0, n - 1);
    t2 = clock_seconds();
    cout << "After quicksort_median_3" << endl;
    check_order(a, n);
    cerr << "median 3 took     " << t2 - t1 << " seconds." << endl;

    cout << "Before quicksort_arm" << endl;
    t1 = clock_seconds();
    quicksort_arm(c, 0, n - 1);
    t2 = clock_seconds();
    cout << "After quicksort_arm" << endl;
    check_order(c, n);
    cerr << "arm median 3 took " << t2 - t1 << " seconds." << endl;

    cout << "Before quicksort_left" << endl;
    t3 = clock_seconds();
    quicksort_left(b, 0, n - 1);
    t4 = clock_seconds();
    cout << "After quicksort_left" << endl;
    check_order(b, n);
    cerr << "left took         " << t4 - t3 << " seconds." << endl;

    cout << "-----------------------------------------" << endl;
    cout << "Try quicksort on sorted list" << endl;


    cout << "Before quicksort_arm on sorted list" << endl;
    t1 = clock_seconds();
    quicksort_arm(a, 0, n - 1);
    t2 = clock_seconds();
    cout << "After quicksort_arm on sorted list" << endl;
    check_order(a, n);
#if DEBUG
    print_list(a, n);
#endif 
    cerr << "arm median 3 took " << t2 - t1 << " seconds." << endl;

    cout << "Before quicksort_left on sorted list" << endl;
    t3 = clock_seconds();
    quicksort_left(b, 0, n - 1);
    t4 = clock_seconds();
    cout << "After quicksort_left on sorted list" << endl;
    check_order(b, n);
#if DEBUG
    print_list(b, n);
#endif 
    cerr << "left took         " << t4 - t3 << " seconds." << endl;

    cout << "Done with quicksort" << endl;

}

////////////////////////////////////////////////////////////////////
//                End median of 3 quicksort                       //
////////////////////////////////////////////////////////////////////

