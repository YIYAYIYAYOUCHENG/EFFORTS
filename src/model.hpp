#ifndef _model_hpp_
#define _model_hpp_

#include <string>
#include "parser.hpp"
#include <ppl.hh>
#include <limits>
#include <exception>
#include <sstream>
#include <math.h>
using namespace Parma_Polyhedra_Library;
//namespace PPL = Parma_Polyhedra_Library;
using namespace Parma_Polyhedra_Library::IO_Operators;
using namespace std;

class Location : public LOCATION
{
public :
        // It task number >= 10, populate does not work
        void populate_signature() {
          signature = 0;
          for (string::iterator x = name.begin(); x != name.end(); x++) {
            if ( *x >= '1' && *x <= '9') {
              unsigned y = *x - '0';
              y = pow(2, y-1);
              signature = signature | y;
            }
          }
        }
        NNC_Polyhedron time_elapse;
        NNC_Polyhedron invar_cvx;
        unsigned int signature;
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
  Param_list cvl; // C-style variable list
  unsigned int signature;
  static int index;
  string state;
  string pre;
  bool valid;
  string label;
  NNC_Polyhedron cvx;
  NNC_Polyhedron widened_cvx;
  bool tk_new;
  shared_ptr<pair_sc> prior;
  vector<Coefficient> maximal_mns;
  vector<Coefficient> maximal_mds;

  vector<shared_ptr<pair_sc> >  childern;

  void clean_children() {
    for (auto it = childern.begin(); it != childern.end(); it++) {
      if ( ! (*it)->valid) continue;
      //cout << (*it)->label << endl;
      (*it)->empty_hard();
      (*it)->clean_children();
    }
  }

  void add_a_child(const shared_ptr<pair_sc> & ch) {
    childern.push_back(ch);
  }

  pair_sc() {}

  pair_sc(string s, const NNC_Polyhedron &cp, const Param_list & kpl, unsigned int sig=0) {
    signature = sig;
    label = s;
    cvx = cp;
    valid=true;
    tk_new = false;
    prior = nullptr;

    cvl = kpl;
    widen();

    stringstream ss;
    ss << index++;
    state = string("s_") + ss.str();
  }

  void empty() {
    //valid = false;
    cvx = NNC_Polyhedron(0, EMPTY);
    //widened_cvx = NNC_Polyhedron(0, EMPTY);
  }
  void empty_hard() {
    valid = false;
    cvx = NNC_Polyhedron(0, EMPTY);
   // widened_cvx = NNC_Polyhedron(0, EMPTY);
  }


  void widen() {
    int d = cvx.space_dimension();
    if (d ==0) return;
    Variables_Set vs;
    vector<Variable> vars;
    for ( int i = 0; i < 2*d; i++)
      vars.push_back(Variable(i));

    widened_cvx = cvx;

    for ( int i = 0; i < d/2; i++) {
      NNC_Polyhedron poly = cvx;
      Constraint cs = (vars[i] >= atoi(cvl.params[3*i].value.c_str()));
      poly.add_constraint(cs);
      if ( ! poly.is_empty()) widened_cvx.unconstrain(vars[i]);
    }

    widened_cvx.add_space_dimensions_and_embed(d);
    for (int i = 0; i < d; i++) {
        vs.insert(vars[i]);
        Constraint cs = (vars[i]>=vars[i+d]);
        widened_cvx.add_constraint(cs);
    }
   
    widened_cvx.remove_space_dimensions(vs);

  }
  
  bool contains(const shared_ptr<pair_sc> &sc, bool sim=false) const {
    if ( !sim) {
      if (label != sc->label) return false;
      return cvx.contains(sc->cvx);
    }
    if ( ! (signature == (signature | sc->signature)))
      return false;
    return widened_cvx.contains(sc->widened_cvx);
  }
  
  // To print 
  void print() {
    cout << "==============================================\n";
    cout << "State : " << state << endl;
    cout << "Valid : " << valid << endl;
    cout << "Pre   : " << pre << endl;
    cout << "Loc   : " << label << endl;
    cout << "Sig   : " << signature << endl;
    //cout << "cvx : \n"; 
    //cout << cvx << endl;
    //cout << "widened_cvx : \n"; 
    //cout << widened_cvx << endl;
    cout << "==============================================\n";
  }
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
  int cpus;
  int N;
  bool ci;
  bool bp;
public:

  bool constrain_release1(const Location*l1);
  bool constrain_release2(const shared_ptr<pair_sc> & sc);
  //bool forward_release(NNC_Polyhedron & poly, unsigned t);
  bool forward_release(const shared_ptr<pair_sc>& state, unsigned ti);
  bool busy_period(unsigned sig);

  map<unsigned int, shared_ptr< list< shared_ptr<pair_sc> > > > passed_map;
  map<unsigned int, shared_ptr< list< shared_ptr<pair_sc> > > > next_map;
  map<unsigned int, shared_ptr< list< shared_ptr<pair_sc> > > > passing_map;
  bool contained_in(map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &m, const shared_ptr<pair_sc> & sc, bool opt, bool debug);
  void insert_into(map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &m, const shared_ptr<pair_sc> &sc);
  void from_a_2_b(map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &a, map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &b);

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
  void  invar_cvx(const Location *l, NNC_Polyhedron &cvx);
  NNC_Polyhedron time_elapse_cvx(const Location *l);
  void time_elapse_cvx(const Location *l, NNC_Polyhedron &cvx);
  void  guard_cvx(const EDGE &e, NNC_Polyhedron &cvx);
  void update_cvx(const EDGE &e, NNC_Polyhedron &cvx);
  void update_cvx2(const EDGE &e, NNC_Polyhedron &cvx);
  
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
  void set_critical_instants() { ci = true;}
  void set_busy_period() { bp = true;}
  void set_cpus(int m) { cpus = m; }

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
