#include<iostream>
using namespace std;

void haha (int i)
{
  cout << i << endl;
}

int main(int argc, char **argv)
{
  int i = 0;
  while ( i < 10000000) {
    i ++;
    haha(i);
  }
}
