#include <iostream>
#include <random>
#include <ctime>

using namespace std;

int main( )
{
    srand( time( NULL ) );
    unsigned i;
    int max, limit;
    cin >> max >> limit;
    for( i = 0; i < limit; i++ )
        cout << rand( ) % max << ' ';
    return 0;
}
