#include <iostream>
#include <random>
#include <ctime>

using namespace std;

int main( )
{
	srand( time( NULL ) );
	unsigned i;
	int min, max, limit;
	cin >> min >> max >> limit;
	for( i = 0; i < limit; i++ )
		cout << rand( ) % ( max * 2 - min ) << ' ';
	return 0;
}
