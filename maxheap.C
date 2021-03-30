
//     Heap insert and delete  [maxheap]
//     Note:  This does a sort but is not technically a heap sort

#include <iostream>
#include <fstream>
#include <ctime>
using namespace std;

const int N_REPEAT = 10000;
const bool DEBUG = true;

extern "C" void swap_int(int &i, int &j);
extern "C" void heap_insert_arm(int a[], int &n, int val);
extern "C" int heap_delete_arm(int a[], int &n);



////////////////////////////////////////////////////////////////////

float clock_seconds()
{
    return clock() / (float) CLOCKS_PER_SEC;
}

////////////////////////////////////////////////////////////////////

void print_list(int a[], int n)
{
    int i;

    for (i = 1; i <= n; i++)
    {
        cout << a[i] << " ";
        if ((i % 10 == 0) && (i < n))
            cout << endl;
    }
    cout << endl;
}

////////////////////////////////////////////////////////////////////

void swap(int &i, int &j)
{
    int old_i;
    int old_j;

    old_i = i;
    old_j = j;

    i = old_j;
    j = old_i;
}

////////////////////////////////////////////////////////////////////

void read_list(int a[], int &n)
{
    ifstream inf;

    inf.open("heaptest.in");
    n = 1;
    inf >> a[n];
    while (!inf.eof())
    {
        n++;
        inf >> a[n];
    }
    n--;
    inf.close();
}

////////////////////////////////////////////////////////////////////

void heap_insert(int a[], int &n, int val)
{
    int i;
    int parent;

    n++;
    a[n] = val;
    if (n == 1)
        return;

    i = n;
    do
    {
        parent = i / 2;
        if (a[i] <= a[parent])
            return;
        swap_int(a[i], a[parent]);
        i = parent;
    } while (i > 1);
}

////////////////////////////////////////////////////////////////////

int heap_delete(int a[], int &n)
{
    int big_child;
    int i;
    int left_child;
    int result;
    int right_child;

    result = a[1];
    if (n == 1)    // one element in heap
    {
        n = 0;
        return result;
    }
    a[1] = a[n];
    n--;
    if (n == 1)  // two elements in heap
        return result;
    i = 1;
    do
    {
        left_child = 2 * i;
        big_child = left_child;
        right_child = left_child + 1;
        if ((right_child <= n) && (a[right_child] > a[left_child]))
            big_child = right_child;
        if (a[i] >= a[big_child])
            return result;
        swap_int(a[i], a[big_child]);
        i = big_child;
    } while (2 * i <= n);
    return result;
}

////////////////////////////////////////////////////////////////////

int main()
{
    int a[200005];
    int heap[200005];
    int sorted[200005];
    int i;
    int n;
    int n_heap;
    int val;
    double end_time;
    double start_time;

    cout << endl << "=======================================" << endl;
    read_list(a, n);
    cout << "List as read:          " << endl;
    print_list(a, n);

    start_time = clock_seconds();
    for (int i_repeat = 0; i_repeat < N_REPEAT; i_repeat++)
    {
        n_heap = 0;
        for (i = 0; i < n; i++)
            heap_insert_arm(heap, n_heap, a[i+1]);
        if (DEBUG && (i_repeat == 0))
        {
            cout << "After loop of insert:  ";
            cout << endl;
            print_list(heap, n);
            cout << "Loop of deletes:       ";
            cout << endl;
        }
        for (i = 0; i < n; i++)
        {
            if (DEBUG && (i_repeat == 0))
                if ((i > 0) && (i % 10 == 0))
                    cout << endl;
            val = heap_delete_arm(heap, n_heap);
            sorted[i] = val;
            if (DEBUG && (i_repeat == 0))
                cout << val << " ";
        }
        if (DEBUG && (i_repeat == 0))
            cout << endl;
    }

    end_time = clock_seconds();
    cerr << "It took " << end_time - start_time << " seconds" << endl;

    // check ordering
    for (i = 0; i < n - 1; i++)
        if (sorted[i] < sorted[i+1])
        {
            cerr << "sorted[" << i << "] = " << sorted[i] << endl;
            cerr << "sorted[" << i+1 << "] = " << sorted[i+1] << endl;
        }
    return 0;
}

////////////////////////////////////////////////////////////////////
