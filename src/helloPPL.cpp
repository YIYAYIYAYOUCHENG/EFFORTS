#include <string>
#include <ppl.hh>
#include <limits>
#include <exception>
#include <sstream>
using namespace Parma_Polyhedra_Library;
//namespace PPL = Parma_Polyhedra_Library;
using namespace Parma_Polyhedra_Library::IO_Operators;
using namespace std;

int main()
{
  NNC_Polyhedron poly(2);
  Variable v0(0);
  Variable v1(1);
  Variable v2(2);

  //Linear_Expression le;
  //le += v;
  Constraint cs = (v0<=10);
  poly.add_constraint(cs);
  cout << poly << endl;
  cs = (v1>=10);
  poly.add_constraint(cs);
  cout << poly << endl;

  //poly.unconstrain(v0);
  cout << poly.space_dimension() << endl;
  Variables_Set vs;
  vs.insert(v1);
  vs.insert(v0);
  //vs.insert(v2);
  poly.unconstrain(vs);
  cout << poly << endl;
  cout << poly.space_dimension() << endl;
  cout << (vs.space_dimension() == 1) << endl;
  cout << (vs.space_dimension()) << endl;

  //cout << cs << endl;

  //le = v;
  //poly.add_constraint(cs);
  //Coefficient mn;
  //Coefficient md;
  //vector<Coefficient> mns;
  //vector<Coefficient> mds;
  //bool is_included;
  //cout << poly.bounds_from_above(le) << endl;
  //poly.maximize(le, mn, md, is_included);
  //mns.push_back(mn);
  //mds.push_back(md);
  //md = 2;
  //cout << "is_included = " << is_included << endl;
  //mds.push_back(1);
  //if (mn/md == 5)
  //  cout << "yes\n";
  //else 
  //  cout << "no\n";
  //if ( mn == 10)
  //cout << poly << endl;
  //poly.add_space_dimensions_and_embed(1);
  //cout << poly << endl;

  //Parma_Polyhedra_Library::operator << (std::cout,  mn); // << " " << md << endl;

  //Constraint cs1 = (le>20);
  //cout << cs << endl;
  //cout << cs1 << endl;

  //poly.add_constraint(cs);
//poly.add_constraint(cs1);

  //cout << poly << endl;

  //poly.remove_higher_space_dimensions(0);

  //cout << poly << endl;
  //cout << poly.is_empty() << endl;

}
