#include "parser.hpp"
#include <fstream>

using namespace std;


int main(int argc, char **argv) {
	
	if (argc < 2) {
		cout << "There is no input file ...\n";
		exit(-1);
	}

	string fn(argv[1]);
	//ifstream input(fname.c_str());
	MODEL mod = parse(fn.c_str());

	mod.print();
}
