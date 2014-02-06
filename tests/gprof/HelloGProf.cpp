#include <iostream>
using namespace std;

void print(int k) {

  cout << k << endl;
}

int main(int argc, char* argv[]) {

  for (int i = 0; i < 1000000; i++)
    print(i);

}
