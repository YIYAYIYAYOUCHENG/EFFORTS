#include "model.hpp"
#include "unique_index.hpp"
#include <fstream>

int pair_sc::index = 0;

static bool find(pair_ss &ss, vector<pair_ss>&v)
{
	for( int i = 0; i < v.size(); i++)
		if( ss.first == v[i].first && ss.second == v[i].second)
			return true;
	return false;
}

static bool is_number(const std::string& s)
{
        std::string::const_iterator it = s.begin();
        if( it != s.end() && (*it == '-')) ++it;
        while (it != s.end() && std::isdigit(*it)) ++it;
            return !s.empty() && it == s.end();
}

static bool contained_in(const string s, const vector<string> &v)
{
    for (int i = 0; i < v.size(); i++)
        if( s == v[i])  return true;
    return false;
}

Automaton::Automaton(const AUTOMATON & aton)
{
	name = aton.name;
	for(  vector<LOCATION>::const_iterator it = aton.locations.begin();
				it != aton.locations.end(); it++) {
		locations.push_back(new Location(*it));
	}
    synclabs = aton.synclabs;
	init = NULL;
}	

Location* Automaton::get_a_location(string l) const
{
	for ( int i = 0; i < locations.size(); i++)
		if( locations[i]->name == l)
			return locations[i];
    return NULL;
}

Location* Automaton::get_init() const
{
	if ( init == NULL) {
        throw "The automaton " + name + " does not have an initial location";
		//cout << " The \"init\" is NULL in automaton \"" << name << "\"\n";
		//exit (1);
	}
	
	return init;
} 

Automaton::~Automaton()
{
	//cout << " The automaton \"" << name << "\" is finishing\n";
	for ( int i = 0; i < locations.size(); i++)
		delete locations[i];
}	

void Automaton::print() const
{
	cout << "--------------------------------------\n";
	cout << "Automaton name \"" << name << "\"\n";
    cout << "synclabs :\n";
    for ( int i = 0; i < synclabs.size(); i++)
        cout << synclabs[i] << endl;
	for( int i = 0; i < locations.size(); i++)
		locations[i]->print();
	cout << "Initial states : ";
	if( init != NULL) cout << init->name << endl;
	cout << "bad states : ";
	for( int i = 0; i < locations.size(); i++)
		if( locations[i]->is_bad)
			cout << locations[i]->name << " ";
	cout << endl;
	cout << "--------------------------------------\n";
}	
		
bool Path::contains (const pair_sc &sc) {
	for( int i = 0; i < sc_path.size(); i++)
		//if( sc_path[i].contains(sc))
		if( sc_path[i].contains(sc) && sc.contains(sc_path[i]))
			return true;
	return false;
}
 
void Path::push_back(const pair_sc &sc, const EDGE &e) {
	sc_path.push_back(sc);
	e_path.push_back(e);
}

void Path::push_back(const pair_sc &sc) {
	sc_path.push_back(sc);
}

void Path::pop_back() {

	if ( sc_path.size() == 0) {
		cout << "Something wrong here \n";	
		exit(-1);
	}
	sc_path.pop_back();
	if( e_path.size() != 0 )
		e_path.pop_back();
}

void Path::print() const {
	//if ( size() == 0)	return;
	//cout << sc_path[0].label; 
	//for ( int i = 0; i < e_path.size(); i++)
	//	cout << " => " << e_path[i].dest;
	//cout << endl;
}

void Path::clear() {
	sc_path.clear();
	e_path.clear();
}


Model::Model(const MODEL &mod)
{
    type = DEF;
    fast_reach = false; 
    fpfp_sim = false;
    op = false;
    // variable list
    var_list = mod.var_list;
    // reserved variable list has been abandoned
    reserved_var_list = mod.reserved_var_list;
    // the parsed parameter list
    param_list = mod.param_list;
    // parameters for IMCR
    im_param_list = mod.im_param_list;
    // the parsed initial declaration
    init = mod.init;
    
    // param_list = known params + unknown params
    Param_list unknown_param_list;
    for ( int i = 0; i < param_list.params.size(); i++)
        if( param_list.params[i].op == "=")
            known_param_list.params.push_back(param_list.params[i]);
        else 
            unknown_param_list.params.push_back(param_list.params[i]);
    param_list = unknown_param_list;

    /** 
     * for now, let's focus on reachability analysis
     **/
     //build_param_list_im();

    for( vector<AUTOMATON>::const_iterator it = 
        mod.automaton_v.begin(); it != mod.automaton_v.end(); it ++) {
			Automaton *aton = new Automaton(*it);	
			string s1 = aton->name;
			for( int i = 0; i < aton->locations.size(); i++) {
				string s2 = aton->locations[i]->name;
				pair_ss ss1(s1, s2);
				aton->locations[i]->is_bad = find(ss1, init.bads);
				if( find(ss1, init.init))
					aton->init = aton->locations[i];
			} 
			automata.push_back(aton);
    }			
		
    cout << "number of automata " << automata.size() << endl;
    for ( int i = 0; i < automata.size(); i++) {
        cout << i << " automaton " << automata[i]->name << endl;
        automata[i]->print();
    }
		
    // Bounded parametric synthesis
    bound = numeric_limits<int>::max();
    cout << "To composite ... ";
    com = automata.at(0);
    for ( int i = 1; i < automata.size(); i++) {
        com = composite(com, automata[i]);
    }
    cout << " Done!\n";
    com->print();

    for ( vector<Location*>::iterator it = com->locations.begin();
         it != com->locations.end(); ++it) {
            for ( int i = 0; i < (*it)->outgoing.size(); i++)
                (*it)->outgoing[i].index = UniqueIndex::get_next_index();
    }

    /** 
     * for now, let's focus on reachability analysis
     **/
    //ff_poly = NNC_Polyhedron(0, EMPTY);
    //line = 0;
}

Model::~Model()
{
	for ( int i = 0; i < automata.size(); i++)
		delete automata[i];
}

NNC_Polyhedron Model::base_cvx() {

  int num_p = param_list.params.size();
  int num_v = var_list.vars.size();
  int dim = 2*num_v + num_p + 1;
  
  NNC_Polyhedron poly(dim);
  vector<Variable> Vars;
  int total = 0;
  
  for ( int i = 0; i < num_p; i++)
    Vars.push_back(Variable(total++));
  for ( int i = 0; i < num_v; i++)
    Vars.push_back(Variable(total++));

  for ( vector<EXPR>::iterator it = init.constraints.begin();
      it != init.constraints.end(); it++) {

    // to analyse each linear constraint

    Linear_Expression le;
    for( int i = 0; i < num_p; i++) {
      le += Vars[i] * it->find(param_list.params[i].name);
    }
    for( int i = 0; i < known_param_list.params.size(); i++) {
      le += atof (known_param_list.params[i].value.c_str()) * 
        it->find(known_param_list.params[i].name);
    }
    for( int i = 0; i < num_v; i++) {
      le += Vars[num_p + i] * it->find(var_list.vars[i]);
    }	
    
    int right = atof(it->value.c_str());
    
    Constraint cs;
    if ( it->op == "<") cs = ( le < right);
    if ( it->op == "=") cs = ( le == right);
    if ( it->op == "<=") cs = ( le <= right);
    if ( it->op == ">") cs = ( le > right);
    if ( it->op == ">=") cs = ( le >= right);
    poly.add_constraint(cs);

  }
  
  return poly;

}

NNC_Polyhedron Model::location_cvx(const Location *l, const NNC_Polyhedron *pre_cvx) {
  
  // a path leading to "target" is found
  if( l->is_bad && type != REACH) {

    if ( type == FAST_REACH) {
      //cout << "The target location is reached\n";
      //return NNC_Polyhedron(0, EMPTY);
      //exit (0);
      fast_reach = true;
    }
    else {
      NNC_Polyhedron bad = *pre_cvx;
      bad.remove_higher_space_dimensions(param_list.params.size());
      //if (bad.is_empty()) 
        //return NNC_Polyhedron(0, EMPTY);
      restore_bad_paths(bad);
      return NNC_Polyhedron(0, EMPTY);
    }

  }
  
  NNC_Polyhedron cvx (*pre_cvx);
  int num_p = param_list.params.size();
  int num_v = var_list.vars.size();
  int dim = 2*num_v + num_p + 1;
  
  vector<Variable> Vars;
  int total = 0;
  for ( int i = 0; i < num_p; i++)
    Vars.push_back(Variable(total++));
  for ( int i = 0; i < num_v; i++)
    Vars.push_back(Variable(total++));

  // invariant
  for ( vector<EXPR>::const_iterator it = l->invar.begin(); it != l->invar.end(); it++) {
    Linear_Expression le;
    for( int i = 0; i < num_p; i++) {
      le += Vars[i] * it->find(param_list.params[i].name);
    }
    for( int i = 0; i < known_param_list.params.size(); i++) {
      le += atof (known_param_list.params[i].value.c_str()) *
        it->find(known_param_list.params[i].name);
    }
    for( int i = 0; i < num_v; i++) {
      le += Vars[num_p + i] * it->find(var_list.vars[i]);
    }
    
    int right = atof(it->value.c_str());
    
    Constraint cs;
    if ( it->op == "<") cs = ( le < right);
    if ( it->op == "=") cs = ( le == right);
    if ( it->op == "<=") cs = ( le <= right);
    if ( it->op == ">") cs = ( le > right);
    if ( it->op == ">=") cs = ( le >= right);
    cvx.add_constraint(cs);
  }
  
  // invar => time elapse
  Vars.push_back(Variable(total++));
  Constraint cs = (Vars[total-1] >= 0);	
  cvx.add_constraint(cs);
  
  for ( int i = 0; i < num_v; i++)
    Vars.push_back(Variable(total++));
  for ( int i = 0; i < num_v; i++) {
    int i2 = total - num_v + i;
    int i1 = num_p + i;
    int i_co = l->rate.find(var_list.vars[i]);
    
    Constraint cs = (Vars[i1] + i_co * Vars[num_p + num_v] == Vars[i2]);
    cvx.add_constraint(cs);
  }
  
  // invar => time elapse => invar
  for ( vector<EXPR>::const_iterator it = l->invar.begin(); it != l->invar.end(); it++) {
    Linear_Expression le;
    for( int i = 0; i < num_p; i++) {
      le += Vars[i] * it->find(param_list.params[i].name);
    }
    for( int i = 0; i < known_param_list.params.size(); i++) {
      le += atof (known_param_list.params[i].value.c_str()) * 
        it->find(known_param_list.params[i].name);
    }
    for( int i = 0; i < num_v; i++) {
      le += Vars[total - num_v + i] * it->find(var_list.vars[i]);
    }
    
    int right = atof(it->value.c_str());
    Constraint cs;
    if ( it->op == "<") cs = ( le < right);
    if ( it->op == "=") cs = ( le == right);
    if ( it->op == "<=") cs = ( le <= right);
    if ( it->op == ">") cs = ( le > right);
    if ( it->op == ">=") cs = ( le >= right);
    cvx.add_constraint(cs);

  }
  
  // invar => time elapse => invar => reduce
  Variables_Set vs;
  for ( int i = total - 2*num_v - 1; i < total - num_v; i++) {
    vs.insert(Vars[i]);
  }
  cvx.remove_space_dimensions(vs);
  cvx.add_space_dimensions_and_embed(num_v+1);
  //total -= (num_2v + 1);
  //Vars.clear();
  //for ( int i = 0; i < total; i++)
  //  Vars.push_back(Variable(i));

  return cvx;

}

NNC_Polyhedron Model::edge_cvx(const EDGE &edge, const NNC_Polyhedron &pre_poly) {
  
  int num_p = param_list.params.size();
  int num_v = var_list.vars.size();
  int dim = 2*num_v + num_p + 1;
  
  const EDGE *it = &edge;
  NNC_Polyhedron cvx = pre_poly;
  string dest = it->dest;
  
  vector<Variable> Vars;
  int total = 0;
  for ( int i = 0; i < num_p; i++)
    Vars.push_back(Variable(total++));
  for ( int i = 0; i < num_v; i++)
    Vars.push_back(Variable(total++));
  
  // guard
  for ( vector<EXPR>::const_iterator iit = it->guard.begin(); iit != it->guard.end(); iit++) {
    Linear_Expression le;
    for( int i = 0; i < num_p; i++) {
      le += Vars[i] * iit->find(param_list.params[i].name);
    }
    for( int i = 0; i < known_param_list.params.size(); i++) {
      le += atof (known_param_list.params[i].value.c_str()) * 
        iit->find(known_param_list.params[i].name);
    }
    for( int i = 0; i < num_v; i++) {
      le += Vars[num_p + i] * iit->find(var_list.vars[i]);
    }
    
    int right = atof(iit->value.c_str());
    Constraint cs;
    if ( iit->op == "<") cs = ( le < right);
    if ( iit->op == "=") cs = ( le == right);
    if ( iit->op == "<=") cs = ( le <= right);
    if ( iit->op == ">") cs = ( le > right);
    if ( iit->op == ">=") cs = ( le >= right);
    cvx.add_constraint(cs);
  
  }
  
  // guard => updates
  for ( int i = 0; i < num_v; i++)
    Vars.push_back(Variable(total++));

  for ( int i = 0; i < num_v; i++) {

    int i2 = total - num_v + i;
    int i1 = num_p + i;
    bool u_flag = false;
    UPDATE update;

    for ( vector<UPDATE>::const_iterator uit = it->updates.begin(); 
        uit != it->updates.end(); uit++) {
      if (var_list.vars[i] == uit->left) {
        u_flag = true;
        update = *uit;
        break;
      }
    }

    Constraint cs;	
    if (!u_flag) {
      cs = (Vars[i2] == Vars[i1]);
      cvx.add_constraint(cs);
      continue;
    }

    Linear_Expression le;
    for( int j = 0; j < num_p; j++) {
      le += Vars[j] * update.find(param_list.params[j].name);
    }
    for( int j = 0; j < known_param_list.params.size(); j++) {
      le += atof (known_param_list.params[j].value.c_str()) * 
        update.find(known_param_list.params[j].name);
    }
    for( int j = 0; j < num_v; j++) {
      le += Vars[num_p + j] * update.find(var_list.vars[j]);
    }
    le += update.get_cons();

    cs = (Vars[i2] == le);
    cvx.add_constraint(cs);

  }
  
  // guard => assign => reduce 
  Variables_Set vs;
  for ( int i = total - 2*num_v; i < total - num_v; i++) {
    vs.insert(Vars[i]);
  }
  cvx.remove_space_dimensions(vs);
  cvx.add_space_dimensions_and_embed(num_v);
  //total -= (num_v);
  //Vars.clear();
  //for ( int i = 0; i < total; i++)
  //  Vars.push_back(Variable(i));

  return cvx;

}

void Model::forward_a_step() {

  int num_p = param_list.params.size();
  int num_v = var_list.vars.size();
  int dim = 2*num_v + num_p + 1;
  
  for ( int k = 0; k < passing.size(); k++) {
    if ( !passing[k].valid) continue;
    //
    Location *l = com->get_a_location(passing[k].label);
    NNC_Polyhedron poly = passing[k].cvx;

    poly.add_space_dimensions_and_embed(num_v+1);
    
    for ( vector <EDGE>::const_iterator it = l->outgoing.begin(); 
        it != l->outgoing.end(); it++) {
      //cout << " => before an edge_cvx\n";
      NNC_Polyhedron cvx = edge_cvx(*it, poly);
      //cout << " => after an edge_cvx\n";

      // to enqueue the latest state in "next queue"
      if( cvx.is_empty()) continue;
      Location *tmp = com->get_a_location(it->dest);
      
      //cout << " => before a location_cvx\n";
      cvx = location_cvx(tmp, &cvx);
      //cout << " => after a location_cvx\n";

      if( type==FAST_REACH && fast_reach) {
        if (cvx.is_empty()) { fast_reach = false; continue; }

        cvx.remove_higher_space_dimensions(var_list.vars.size());

        pair_sc sc(it->dest,cvx);
        sc.pre = passing[k].state;
        next.push_back(sc);
        //cout << "The target is reached. Fast saving ...\n";
        fast_save();
        throw 0;
      }

      if( cvx.is_empty()) continue;
      
      cvx.remove_higher_space_dimensions(var_list.vars.size());

      pair_sc sc(it->dest, cvx);
      bool flag = true;
      for( int i = 0; i < passed.size(); i++) { 
        if ( !passed[i].valid) continue;
        if( passed[i].contains(sc, fpfp_sim)) { 
          flag = false;
          break;
        }
        // If "optimized" option is set, all redundent "passed" states will be removed
        if ( op == true) {
          if (sc.contains(passed[i], fpfp_sim)) {
              passed[i].empty();
          }
        }
      }
      
      if( flag)
        for( int i = 0; i < next.size(); i++) { 
          if (!next[i].valid) continue;
          if( next[i].contains(sc, fpfp_sim)) { 
            flag = false; 
            break;
          }
          else if ( sc.contains(next[i], fpfp_sim))
              next[i].empty();
        }
      
      if( flag)
        for( int i = 0; i < passing.size(); i++) {
          if ( !passing[i].valid) continue;
          if( passing[i].contains(sc, fpfp_sim)) { 
            flag = false; 
            break;
          }
          else if(sc.contains(passing[i], fpfp_sim))
            passing[i].empty();
        }
      
      if( flag) {    
        sc.pre = passing[k].state;
        next.push_back(sc);
      }
    }			
  }
}
    
void Model::restore_bad_paths(NNC_Polyhedron poly)
{
    vector<NNC_Polyhedron> tmp = bad_paths;
    bad_paths.clear();
    for( int i = 0; i < tmp.size(); i++) {
        if( poly.contains(tmp[i]))  continue;
        if( tmp[i].contains(poly)) {
            for( int j = i; j < tmp.size(); j++)
                bad_paths.push_back(tmp[j]);
            return;
        }
        bad_paths.push_back(tmp[i]);
    }
    bad_paths.push_back(poly);
}

static void clean_pair_sc_v_partial_order(vector<pair_sc> &v, 
    int n=numeric_limits<int>::max()) {
  int k = 0;
  while (k < v.size()) {
    int s = v.size();
    bool flag = true;
    int ub = s-k-1;
    if (s-n-1 > 0)
      ub = s-n-1;
    for ( int j = 0; j < ub; j++) {
      if (!v[s-k-1].contains(v[j]))
        continue;
      //cout << "Got one!\n";
      for (int r = j; r < s-1; r++)
        v[r] = v[r+1];
      v.pop_back();
      flag = false;
      break;
    }
    if (flag) k++;
    if (k > n) 
      return;
  }
}

static void clean_pair_sc_v(vector<pair_sc> &v,
    int n=numeric_limits<int>::max()) {

    int K = v.size();
    int ub = K - 1;
    if ( K-n-1 >= 0)
      ub = K - n - 1;
    for ( int i = 0; i <= ub; i++) {
        if ( !v[i].valid)
          continue;
        for ( int j = K-n; j < K; j++) {
            if( v[j].contains(v[i])) {
                pair_sc psc(v[i]);
                psc.valid=false;
                v[i]=psc;
                break;
            }
        }
    }
}

void Model::fast_save() {
  for ( int i = 0; i < passing.size(); i++)
    if (passing[i].valid)
      passed.push_back(passing[i]);
  //clean_pair_sc_v(passed, passing.size());

  //clean_pair_sc_v_partial_order(next);
  for ( int i = 0; i < next.size(); i++)
    if (next[i].valid)
      passed.push_back(next[i]);
  //clean_pair_sc_v(passed, next.size());
}

void Model::sat() {

  //sat
  for ( int i = 0; i < passing.size(); i++)
    if (passing[i].valid)
      passed.push_back(passing[i]);
  passing.clear();
  for ( int i = 0; i < next.size(); i++)
    if (next[i].valid)
      passing.push_back(next[i]);
  next.clear();
  cout << " Number of generated states: " << passing.size() << endl;
  cout << " Number of states passed: " << passed.size() << endl;
  int cv = 0;
  for (int i = 0; i < passed.size(); i++)
    if (passed[i].valid)  cv ++;
  cout << " Number of valid states passed: " << cv << endl;
  cout << " ------------------------------------ \n";
}

void Model::bf_psy()
{
  int index = 0;
  cout << "step " << index++ << endl;
  NNC_Polyhedron base = base_cvx();
  NNC_Polyhedron starting_point = location_cvx(com->init, &base);

  starting_point.remove_higher_space_dimensions(var_list.vars.size());

  passing.push_back(pair_sc(com->init->name, starting_point));
  forward_a_step();

  while(!next.empty()) {
    cout << " ------------------------------------ \n";
    cout << "step " << index++ << endl;
    sat();
    forward_a_step();
    cout << " ------------------------------------ \n";
    
  }
  
  for( int i = 0; i < bad_paths.size(); i++) {
    cout << "bad path : " << i << endl;
    cout << bad_paths[i] << endl;
  }
}

void Model::print_log(string lname)
{
  std::ofstream out(lname.c_str());
  streambuf *coutbuf = cout.rdbuf(); //save old buf
  cout.rdbuf(out.rdbuf()); //redirect std::cout to out.txt!

  for (int i =0; i < passed.size(); i++)
    passed[i].print();

  cout.rdbuf(coutbuf);
  
}

Automaton* composite(const Automaton *aton1, const Automaton *aton2)
{
    Automaton * aton = new Automaton();
    aton->name = aton1->name + aton2->name;

    for( int i = 0; i < aton1->locations.size(); i++) {
        for( int j = 0; j < aton2->locations.size(); j++) {
            Location *l = com_2_locs(aton1->locations[i], aton2->locations[j], aton1, aton2);
            aton->locations.push_back(l);
            if( aton1->locations[i] == aton1->init && aton2->locations[j] == aton2->init)
                aton->init = l;
        }
    }
    for ( int i = 0; i < aton1->synclabs.size(); i++)
        aton->synclabs.push_back(aton1->synclabs[i]);
    for ( int i = 0; i < aton2->synclabs.size(); i++)
        aton->synclabs.push_back(aton2->synclabs[i]);
    return aton;           
}

Location *com_2_locs(const Location *l1, const Location *l2, const Automaton *aton1, const Automaton *aton2)
{
    string ln = l1->name + l2->name;
    Location *l = new Location();
    l->name = ln;
    l->is_bad = ( l1->is_bad || l2->is_bad);

    if (l->is_bad) return l;

    for( vector<EXPR>::const_iterator it = l1->invar.begin();
                    it != l1->invar.end(); ++it) 
        l->invar.push_back(*it);
    for( vector<pair_ss>::const_iterator it = l1->rate.assign_atoms.begin();
                    it != l1->rate.assign_atoms.end(); ++it) 
        l->rate.assign_atoms.push_back(*it);
    for( vector<EXPR>::const_iterator it = l2->invar.begin();
                    it != l2->invar.end(); ++it) 
        l->invar.push_back(*it);
    for( vector<pair_ss>::const_iterator it = l2->rate.assign_atoms.begin();
                    it != l2->rate.assign_atoms.end(); ++it) 
        l->rate.assign_atoms.push_back(*it);
    
    for( vector<EDGE>::const_iterator it = l1->outgoing.begin();
                it != l1->outgoing.end(); it++) {
        EDGE e1 = *it;
        string slab1 = e1.sync;
        string next1 = e1.dest;
        if ( !contained_in(slab1, aton2->synclabs)) {
            EDGE e = e1;
            e.dest = next1 + l2->name;
            l->outgoing.push_back(e);
        }
        if ( contained_in(slab1, aton2->synclabs)) {
            for( vector<EDGE>::const_iterator it2 = l2->outgoing.begin();
                        it2 != l2->outgoing.end(); it2++) {
                EDGE e;
                EDGE e2 = *it2;
                string slab2 = e2.sync;
                string next2 = e2.dest;
                if( slab1 == slab2) {
                    for( vector<EXPR>::const_iterator iit = e1.guard.begin();
                                    iit != e1.guard.end(); ++iit) 
                        e.guard.push_back(*iit);
                    //for( vector<pair_ss>::const_iterator iit = e1.ass.assign_atoms.begin();
                    //                iit != e1.ass.assign_atoms.end(); ++iit) 
                    //    e.ass.assign_atoms.push_back(*iit);
                    for( vector<UPDATE>::const_iterator iit = e1.updates.begin();
                                    iit != e1.updates.end(); ++iit) 
                        e.updates.push_back(*iit);
                    for( vector<EXPR>::const_iterator iit = e2.guard.begin();
                                    iit != e2.guard.end(); ++iit) 
                        e.guard.push_back(*iit);
                    //for( vector<pair_ss>::const_iterator iit = e2.ass.assign_atoms.begin();
                    //                iit != e2.ass.assign_atoms.end(); ++iit) 
                    //    e.ass.assign_atoms.push_back(*iit);
                    for( vector<UPDATE>::const_iterator iit = e2.updates.begin();
                                    iit != e2.updates.end(); ++iit) 
                        e.updates.push_back(*iit);
    
                    e.sync = slab1;
                    e.dest = next1 + next2;
                    l->outgoing.push_back(e);
                    
                }
            }
        }
            
    }
    for( vector<EDGE>::const_iterator it = l2->outgoing.begin();
                it != l2->outgoing.end(); it++) {
        EDGE e2 = *it;
        string slab2 = e2.sync;
        string next2 = e2.dest;
        if ( !contained_in(slab2, aton1->synclabs)) {
            EDGE e = e2;
            e.dest = l1->name + next2;
            l->outgoing.push_back(e);
        }
    }

    return l;
}

// delete "//" to recover uncommented content
//void Model::build_param_list_im()
//{
//    param_list0 = param_list;
//    known_param_list0 = known_param_list;
//    known_param_list1 = known_param_list;
//
//    for ( vector<Param>::iterator it = param_list.params.begin();
//                            it != param_list.params.end(); it++ ) {
//        bool flag = true;
//        for ( vector<Param>::iterator iit = im_param_list.params.begin();
//                                iit != im_param_list.params.end(); iit++ ) {
//            if( it->name == iit->name) { flag = false; break; }
//        }
//        if( flag)   param_list1.params.push_back(*it);
//    }
//    for ( vector<Param>::iterator it = im_param_list.params.begin();
//                            it != im_param_list.params.end(); it++ )
//        known_param_list1.params.push_back(*it);
//
//    cout << "param_list1 :\n";
//    for( int i = 0; i < param_list1.params.size(); i++)
//        cout << param_list1.params[i].name << endl;
//    cout << "known_param_list1 :\n";
//    for( int i = 0; i < known_param_list1.params.size(); i++)
//        cout << known_param_list1.params[i].name << endl;
//}
//
///**************************************************************************/
///**			Inverse Method with Complete Result							 **/
///**************************************************************************/
//
//void Model::imcr()
//{
//    Path path;
//    imi_swap_param(1);
//	NNC_Polyhedron cvx = base_cvx();
//	path.push_back(pair_sc(com->init->name, cvx));
//	if( cvx.is_empty()) {
//		psy_an_unfeasible_path(path);
//		return;
//	}
//    path_explorer(path);
//}
//
//void Model::path_explorer(Path &path)
//{
//	cout << "enter path_explorer : \n";
//    imi_swap_param(1);
//    path.print();
//    int num_p = param_list.params.size();
//    int num_v = var_list.vars.size();
//    int num_rv = reserved_var_list.vars.size();
//    int num_2v = num_v + num_rv;
//    int dim = 2*num_2v + param_list.params.size() + 1;
//    Location *l;
//    NNC_Polyhedron poly;
//
//	l = com->get_a_location(path.sc_path.back().label);
//	poly = path.sc_path.back().cvx;
//
//	// A feasible path is found
//    if( l->outgoing.size() == 0) {
//		psy_a_feasible_path(path); 
//		//l->print();
//		cout << " A feasible path is found\n";
//		//path.pop_back();
//		return;
//    }
//
//    for ( vector<EDGE>::const_iterator it = l->outgoing.begin();
//                            it != l->outgoing.end(); it++) {
//		string dest = it->dest;
//		EDGE edge = *it;
//		NNC_Polyhedron cvx = edge_cvx(edge, poly);
//
//		// An unfeasible path is found on the edge
//		if( cvx.is_empty()) {
//           	path.push_back(pair_sc(dest,cvx), edge);
//           	psy_an_unfeasible_path(path);
//			cout << " An unfeasible path is found on the edge\n";
//           	path.pop_back();
//           	continue;
//		}
//       
//   		Location *tmp = com->get_a_location(dest);
//       	cvx = location_cvx(com->get_a_location(dest), &cvx);
//
//		// An unfeasible path is found in the location
//       	if( cvx.is_empty()) {
//           	path.push_back(pair_sc(dest,cvx), edge);
//           	psy_an_unfeasible_path(path);
//			cout << " An unfeasible path is found in the location\n";
//           	path.pop_back();
//           	continue;
//       	}
//
//		// A feasible path is found
//		//if( path.contains(pair_sc(dest, cvx))) {
//		pair_sc curr(dest, cvx);
//		if( path.contains(curr)) {
//           	path.push_back(pair_sc(dest,cvx), edge);
//           	psy_a_feasible_path(path);
//			cout << " An cyclic feasible path is found\n";
//           	path.pop_back();
//        	continue;
//       	} 
//
//		// Got deeper
//       	path.push_back(pair_sc(dest,cvx), edge);
//       	path_explorer(path);
//		cout << "back one step\n";
//		//cout << path.sc_path.back().label << endl;
//       	path.pop_back();
//	}
//                      
//}
//
//void Model::psy_a_feasible_path(const Path& path)
//{
//	
//	cout << " psy a feasible path : line = " << ++ line ;
//	cout << " , depth = " << path.e_path.size() << endl;
//
////    imi_swap_param(0);
//////
////    int num_p = param_list.params.size();
////    int num_v = var_list.vars.size();
////    int num_rv = reserved_var_list.vars.size();
////    int num_2v = num_v + num_rv;
////    int dim = 2*num_2v + param_list.params.size() + 1;
////
////    NNC_Polyhedron poly = base_cvx();
////
////    for( vector<EDGE>::const_iterator it = path.e_path.begin();
////                    it != path.e_path.end(); it++) {
////       string dest = it->dest;
////       EDGE edge = *it;
////
////       NNC_Polyhedron cvx = edge_cvx(edge, poly);
////
////       poly = location_cvx(com->get_a_location(dest), &cvx);
////    }
////
////    poly.remove_higher_space_dimensions(num_p);
////
////	//if( !poly.is_empty())
////	if( !ff_poly.is_empty()) ff_poly.intersection_assign(poly);	
////	else	ff_poly = poly;
//////	
//	Path p;
//	p.e_path = path.e_path;
//    feasible_path_set.push_back(p);
////
////    imi_swap_param(1);
//}
//
//void Model::psy_an_unfeasible_path(const Path& path)
//{
//	cout << " psy an unfeasible path : line = " << ++ line ;
//	cout << " , depth = " << path.e_path.size() << endl;
//
//////
////    imi_swap_param(0);
////
////    int num_p = param_list.params.size();
////    int num_v = var_list.vars.size();
////    int num_rv = reserved_var_list.vars.size();
////    int num_2v = num_v + num_rv;
////    int dim = 2*num_2v + param_list.params.size() + 1;
////
////    NNC_Polyhedron poly = base_cvx();
////	
////	// The pre-unfeasible poly when there is only
////	// one edge.
////	if( path.e_path.size() == 1) {
////		NNC_Polyhedron p = poly;
////	   	p.remove_higher_space_dimensions(num_p);
////		if( !p.is_empty())
////			if( ff_poly.is_empty())	ff_poly = p;	
////			else	ff_poly.intersection_assign(p);	
////	}	
////	
////    for( vector<EDGE>::const_iterator it = path.e_path.begin();
////                    it != path.e_path.end(); it++) {
////		string dest = it->dest;
////       	EDGE edge = *it;
////       	NNC_Polyhedron cvx = edge_cvx(edge, poly);
////
////       	poly = location_cvx(com->get_a_location(dest), &cvx);
////       	if( it == path.e_path.end() - 2) {
////       	    NNC_Polyhedron p = poly;
////    		p.remove_higher_space_dimensions(num_p);
////			if( !p.is_empty())
////				if( ff_poly.is_empty())	ff_poly = p;	
////				else	ff_poly.intersection_assign(p);	
////       	} 
////
////    }
//////
//    imi_swap_param(1);
//    Path p;
//////
////	if ( poly.is_empty()) return;
////    poly.remove_higher_space_dimensions(num_p);
////    p.poly = poly;
//////
//    p.e_path = path.e_path;
//    unfeasible_path_set.push_back(p);
//	//cout <<"Number of unfeasible paths: " << unfeasible_path_set.size() << endl;
//}
//
//void a_test()
//{
//	Linear_Expression e1, e2, e3;
//	cout << "e1 : " << e1 << endl;
//	cout << "e2 : " << e2 << endl;
//	cout << "e3 : " << e3 << endl;
//	e1 += 32;
//	cout << "e1 : " << e1 << endl;
//	e2 += -32;
//	cout << "e2 : " << e2 << endl;
//	int tmp1 = 231;
//	int tmp2 = -1;
//	e3 += tmp1 * tmp2;
//	cout << "e3 : " << e3 << endl;
//	
//    //vector<pair_sc> v;
//    //pair_sc sc("haha", NNC_Polyhedron(2));
//    //pair_sc sc2("haha", NNC_Polyhedron(2, EMPTY));
//    //v.push_back(sc2);
//    //v.push_back(sc2);
//    //v.push_back(sc);
//    //v.push_back(sc);
//    //v.push_back(sc);
//    //cout << " before clean " << v.size();
//    //clean_pair_sc_v(v);
//    //cout << " after clean " << v.size();
//}