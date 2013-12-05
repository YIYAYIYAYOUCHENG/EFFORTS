#ifndef _model_hpp_
#define _model_hpp_

#include <string>
#include "parser.hpp"
#include <ppl.hh>
#include <limits>
#include <exception>
#include <sstream>
using namespace Parma_Polyhedra_Library;
//namespace PPL = Parma_Polyhedra_Library;
using namespace Parma_Polyhedra_Library::IO_Operators;
using namespace std;

class Location : public LOCATION
{
public :
	Location () {}
	Location(const LOCATION &loc) {
		name = loc.name;
		invar = loc.invar;
		rate = loc.rate;
		outgoing = loc.outgoing;
		is_bad = loc.is_bad;
	}

};

class Edge : public EDGE
{
public :
	Edge(const EDGE &e) {
		guard = e.guard;
		sync = e.sync;
		ass = e.ass;
		dest = e.dest;
		index = e.index;
	}
};

class Automaton :public AUTOMATON{
public :
	
	vector<Location*> locations;	
	Location *init;
	Automaton(){}
	Automaton(const AUTOMATON &automaton);
    // Return the pointer to the location with name l;
    // NULL will be returned if the name does not match a location
	Location* get_a_location(string l) const;
    // Return pointer to the initial location.
    // If the initial pointer is NULL, an exception will be thrown.
    // This method is never called anywhere ...
	Location *get_init() const;
	~Automaton();
	void print() const;

};

// A help struct consisting of a label (string) and a NNC convex polyhedron
struct pair_sc {
  static int index;
  string state;
  string pre;
  bool valid;
  string label;
  NNC_Polyhedron cvx;
  NNC_Polyhedron widened_cvx;
  vector<Coefficient> maximal_mns;
  vector<Coefficient> maximal_mds;

  pair_sc(string s, NNC_Polyhedron cp) {
    label = s;
    cvx = cp;
    valid=true;

    fill_maximals();
    widen();

    stringstream ss;
    ss << index++;
    state = string("s_") + ss.str();
  }

  void empty() {
    valid = false;
    cvx = NNC_Polyhedron(0, EMPTY);
    widened_cvx = NNC_Polyhedron(0, EMPTY);
  }

  void fill_maximals() {
    int d = cvx.space_dimension();
    if ( d==0) return;
    vector<Variable> vars;
    for ( int i = 0; i < d; i++) {
      vars.push_back(Variable(i));
      Linear_Expression le = vars[i];
      bool bounded = cvx.bounds_from_above(le);
      Coefficient mn;
      Coefficient md;
      if (!bounded) {
        mn = numeric_limits<int>::max();
        md = 1;
      }
      else {
        bool is_included;
        cvx.maximize(le, mn, md, is_included);
      }
      maximal_mns.push_back(mn);
      maximal_mds.push_back(md);
    }
  }

  void widen() {
    int d = cvx.space_dimension();
    if (d ==0) return;
    vector<Variable> vars;
    for ( int i = 0; i < 2*d; i++)
      vars.push_back(Variable(i));
    widened_cvx = cvx;
    widened_cvx.add_space_dimensions_and_embed(d);
    Variables_Set vs;
    for (int i = 0; i < d; i++) {
      vs.insert(vars[i]);
      Constraint cs = (vars[i]>=vars[i+d]);
      widened_cvx.add_constraint(cs);
    }
   
    widened_cvx.remove_space_dimensions(vs);

  }
  
  // To check if two pairs equal.
  bool equals(const pair_sc &sc) const {
    if (label != sc.label) return false;
    return cvx.contains(sc.cvx) && sc.cvx.contains(cvx);
  }
    
  // To check if this pair contains another pair
  //bool contains(const pair_sc &sc) const {
  //  if (label != sc.label) return false;
  //  return cvx.contains(sc.cvx);
  //}
  bool contains(const pair_sc &sc, bool sim=false) const {
    if ( !sim) {
      if (label != sc.label) return false;
      return cvx.contains(sc.cvx);
    }
    if ( not_contains(sc))  return false;
    return widened_cvx.contains(sc.widened_cvx);
  }
  
  // sc1 cannot contain sc2 if there is a maximal value from sc2
  // that is larger than the corresponding maximal value in sc1
  bool not_contains(const pair_sc &sc2) const {
    for ( unsigned i = 0; i < maximal_mns.size(); i++)
      if ( sc2.maximal_mns[i]/sc2.maximal_mds[i] > maximal_mns[i]/maximal_mds[i])
        return true;
    return false;
  }

  // To print 
  void print() {
    cout << "==============================================\n";
    cout << "State : " << state << endl;
    cout << "Valid : " << valid << endl;
    cout << "Pre   : " << pre << endl;
    cout << "Loc   : " << label << endl;
    cout << "cvx : \n"; 
    cout << cvx << endl;
    cout << "widened_cvx : \n"; 
    cout << widened_cvx << endl;
    cout << "==============================================\n";
  }
};

class Path {

public :
	vector < pair_sc > sc_path; // a line of Node ids

	// Since there could be multiple edges between two nodes,
	// e_path is used to indetify a Path.
    vector <EDGE> e_path;	
    
	NNC_Polyhedron poly; // The final synthesized poly of the path

	// Return the number of nodes in the path
    bool contains (const pair_sc &sc);

    void push_back(const pair_sc &sc, const EDGE &e) ;

    void push_back(const pair_sc &sc) ;

    void pop_back() ;

    void print() const ;

	void clear() ;
};

// The xtool can deal with 3 kinds of operations :
// reachability analysis, parameter synthesis and
// inverse method with complete result.
enum ModelAnalysisType { DEF, REACH, PSY, IMCR, FAST_REACH };

//a PLHA model
class Model :public MODEL {
  int line; // no idea
  bool fast_reach;
  bool fpfp_sim;
  bool op;
public:

  ModelAnalysisType type;
  
  Param_list known_param_list; // constants
  
  Model () : type(DEF) {}

  Model (const MODEL & mod);
	
  /**
   *  In the first step, all input automata
   *  are parsed and stored in this vector.
   **/
  vector<Automaton*> automata;
	
  /**
   *  *com is the final composite of all 
   *  automata in the input file
   **/
  Automaton *com;
  
  ~Model();
  
  int bound; // to bound the number of steps

  vector<NNC_Polyhedron> bad_paths; // not a good name

  // to return the convex space representing initial constraints
  NNC_Polyhedron base_cvx();
  
  NNC_Polyhedron location_cvx(const Location *l, const NNC_Polyhedron *pre_poly);
	
  NNC_Polyhedron edge_cvx(const EDGE &edge, const NNC_Polyhedron &pre_poly);

	
  vector<pair_sc> next;
  vector<pair_sc> passing;
  vector<pair_sc> passed;
  
  void forward_a_step();

  /** Parameter synthesis by breadth first iteration. **/
  void bf_psy();
  void sat();
  void fast_save();
  void restore_bad_paths(NNC_Polyhedron poly);
  void print_log(string lname=".log");
  void set_fpfp_sim() { fpfp_sim = true;}
  void set_op() { op = true;}

//    /**************** IMCR **********************/
//    vector<Path> feasible_path_set;
//	
//	NNC_Polyhedron ff_poly; // The final feasible polyhedron
//
//    vector<Path> unfeasible_path_set;
//    
//    void imcr();
//    void path_explorer(Path &p);
//    void psy_a_feasible_path(const Path &path);
//    void psy_an_unfeasible_path(const Path &path);
//    /********************************************/
//
//private :
//	/** 
//	 *	param_list0 includes im parameters;
//	 *	known_param_list0 does not include im parameters.
//	 **/
//    Param_list param_list0;
//    Param_list known_param_list0;
//	/** 
//	 *	param_list1 does not include im parameters;
//	 *	known_param_list1 includes im parameters.
//	 **/
//    Param_list param_list1;
//    Param_list known_param_list1;
//
//    void build_param_list_im();
//    void imi_swap_param(int o) {
//        if( o == 0) {
//            param_list = param_list0;
//            known_param_list = known_param_list0;
//        }
//        if( o == 1) {
//            param_list = param_list1;
//            known_param_list = known_param_list1;
//        }
//    }
//
//	
};

Automaton* composite(const Automaton *aton1, const Automaton *aton2);
Location *com_2_locs(const Location *l1, const Location *l2, const Automaton *aton1, const Automaton *aton2);

void a_test();

#endif
