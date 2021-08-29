#include <iostream>
#include <random>
#include <ctime>

#include "constants.h"

using namespace std;

int main( )
{
    srand( time( NULL ) );
    unsigned i;
    for( i = 0; i < LIMIT; i++ )
        cout << rand( ) % MAX << ' ';
}
