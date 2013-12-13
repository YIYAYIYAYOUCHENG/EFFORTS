#include "model.hpp"
#include "unique_index.hpp"
#include <fstream>

int pair_sc::index = 0;

static bool find(pair_ss &ss, vector<pair_ss>&v)
{
    for ( unsigned i = 0; i < v.size(); i++)
	if( ss.first == v[i].first && ss.second == v[i].second)
	    return true;
    return false;
}

// static bool is_number(const std::string& s)
// {
//     std::string::const_iterator it = s.begin();
//     if( it != s.end() && (*it == '-')) ++it;
//     while (it != s.end() && std::isdigit(*it)) ++it;
//     return !s.empty() && it == s.end();
// }

static bool contained_in(const string s, const vector<string> &v)
{
    for (unsigned i = 0; i < v.size(); i++)
        if( s == v[i])  return true;
    return false;
}

Automaton::Automaton(const AUTOMATON & aton)
{
    name = aton.name;
    for (vector<LOCATION>::const_iterator it = aton.locations.begin();
	  it != aton.locations.end(); it++) {
	locations.push_back(new Location(*it));
    }
    synclabs = aton.synclabs;
    init = NULL;
}	

Location* Automaton::get_a_location(string l) const
{
    for (unsigned i = 0; i < locations.size(); i++)
	if( locations[i]->name == l)
	    return locations[i];
    return NULL;
}

Location* Automaton::get_init() const
{
    if (init == NULL) {
        throw "The automaton " + name + " does not have an initial location";
	//cout << " The \"init\" is NULL in automaton \"" << name << "\"\n";
	//exit (1);
    }
	
    return init;
} 

Automaton::~Automaton()
{
    //cout << " The automaton \"" << name << "\" is finishing\n";
    for (unsigned i = 0; i < locations.size(); i++)
	delete locations[i];
}	

void Automaton::print() const
{
    cout << "--------------------------------------\n";
    cout << "Automaton name \"" << name << "\"\n";
    cout << "synclabs :\n";
    for (unsigned i = 0; i < synclabs.size(); i++)
        cout << synclabs[i] << endl;
    for (unsigned i = 0; i < locations.size(); i++)
	locations[i]->print();
    cout << "Initial states : ";
    if( init != NULL) cout << init->name << endl;
    cout << "bad states : ";
    for ( unsigned i = 0; i < locations.size(); i++)
	if( locations[i]->is_bad)
	    cout << locations[i]->name << " ";
    cout << endl;
    cout << "--------------------------------------\n";
}	
		
Model::Model(const MODEL &mod)
{
    type = DEF;
    fast_reach = false; 
    fpfp_sim = false;
    op = false;
    cpus = 2;
    ci = false;
    bp = false;
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
    for (unsigned i = 0; i < param_list.params.size(); i++)
        if( param_list.params[i].op == "=")
            known_param_list.params.push_back(param_list.params[i]);
        else 
            unknown_param_list.params.push_back(param_list.params[i]);
    param_list = unknown_param_list;

    /** 
     * for now, let's focus on reachability analysis
     **/
    //build_param_list_im();

    for ( vector<AUTOMATON>::const_iterator it = 
	     mod.automaton_v.begin(); it != mod.automaton_v.end(); it ++) {
	Automaton *aton = new Automaton(*it);	
	string s1 = aton->name;
	for ( unsigned i = 0; i < aton->locations.size(); i++) {
	    string s2 = aton->locations[i]->name;
	    pair_ss ss1(s1, s2);
	    aton->locations[i]->is_bad = find(ss1, init.bads);
	    if( find(ss1, init.init))
		aton->init = aton->locations[i];
	} 
	automata.push_back(aton);
    }			
		
    //cout << "number of automata " << automata.size() << endl;
    //for (unsigned i = 0; i < automata.size(); i++) {
    //    cout << i << " automaton " << automata[i]->name << endl;
    //    automata[i]->print();
    //}
		
    // Bounded parametric synthesis
    bound = numeric_limits<int>::max();
    cout << "To composite ... ";
    com = automata.at(0);
    for (unsigned i = 1; i < automata.size(); i++) {
        com = composite(com, automata[i]);
    }
    cout << " Done!\n";
    //com->print();

    for (vector<Location*>::iterator it = com->locations.begin();
	  it != com->locations.end(); ++it) {
        (*it)->populate_signature();
	for (unsigned i = 0; i < (*it)->outgoing.size(); i++) {
	    (*it)->outgoing[i].index = UniqueIndex::get_next_index();
            //(*it)->outgoing[i].guard_cvx = guard_cvx( (*it)->outgoing[i] );
        }
        (*it)->time_elapse = time_elapse_cvx(*it);

        passed_map[(*it)->signature] = make_shared< list<shared_ptr<pair_sc> > > ();
        passing_map[(*it)->signature] = make_shared< list<shared_ptr<pair_sc> > > ();
        next_map[(*it)->signature] = make_shared< list<shared_ptr<pair_sc> > > ();
    }

    N = var_list.vars.size() / 2;
    /** 
     * for now, let's focus on reachability analysis
     **/
    //ff_poly = NNC_Polyhedron(0, EMPTY);
    //line = 0;
}

Model::~Model()
{
    for (unsigned i = 0; i < automata.size(); i++)
	delete automata[i];
}

NNC_Polyhedron Model::base_cvx() {
  
  int dim = var_list.vars.size();
  
  NNC_Polyhedron poly(dim);
  vector<Variable> Vars;
  
  for ( int i = 0; i < dim; i++)
    Vars.push_back(Variable(i));

  for ( vector<EXPR>::iterator it = init.constraints.begin();
      it != init.constraints.end(); it++) {

    Linear_Expression le;
    for ( int i = 0; i < known_param_list.params.size(); i++) {
      int co = it->find(known_param_list.params[i].name);
      if ( co != 0)
        le += atof (known_param_list.params[i].value.c_str()) * co;
    }
    for ( int i = 0; i < dim; i++) {
      int co = it->find(var_list.vars[i]);
      if ( co != 0)
        le += Vars[i] * it->find(var_list.vars[i]);
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

void Model::invar_cvx(const Location *l, NNC_Polyhedron &cvx) {
  
    int dim = var_list.vars.size();
    //NNC_Polyhedron cvx(dim);
  
    vector<Variable> Vars;
    for (int i = 0; i < dim; i++)
	Vars.push_back(Variable(i));

    // invariant
    for ( vector<EXPR>::const_iterator it = l->invar.begin(); 
        it != l->invar.end(); it++) {

	Linear_Expression le;

        for ( int i = 0; i < known_param_list.params.size(); i++) {
          int co = it->find(known_param_list.params[i].name);
          if ( co != 0)
            le += co * atof (known_param_list.params[i].value.c_str());
        }
	for ( int i = 0; i < dim; i++) {
          int co = it->find(var_list.vars[i]);
          if ( co != 0)
	    le += Vars[i] * it->find(var_list.vars[i]);
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
  
}

void Model::guard_cvx(const EDGE &edge, NNC_Polyhedron &cvx) {
  
    int dim = var_list.vars.size();
  
    const EDGE *it = &edge;
    //NNC_Polyhedron cvx(dim);
  
    vector<Variable> Vars;
    for ( int i = 0; i < dim; i++)
	Vars.push_back(Variable(i));
  
    // guard
    for ( vector<EXPR>::const_iterator iit = it->guard.begin(); 
        iit != it->guard.end(); iit++) {
	Linear_Expression le;
        for ( int i = 0; i < known_param_list.params.size(); i++) {
          int co = iit->find(known_param_list.params[i].name);
          if ( co != 0) 
            le += atof (known_param_list.params[i].value.c_str()) * co;
        }
	for ( int i = 0; i < dim; i++) {
          int co = iit->find(var_list.vars[i]);
          if ( co != 0)
	    le += Vars[i] * co;
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
  
}

void Model::update_cvx2(const EDGE &edge, NNC_Polyhedron &cvx) {

  
    int dim = var_list.vars.size();
  
    const EDGE *it = &edge;
  
    vector<Variable> Vars;
    for ( int i = 0; i <= 2*dim; i++)
	Vars.push_back(Variable(i));

    Variables_Set vs;

    cvx.add_space_dimensions_and_embed(dim);

    for ( int i = 0; i < dim; i++) {

        vs.insert(Vars[i]);

	int i2 = dim + i;
	
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
	    cs = (Vars[i2] == Vars[i]);
	    cvx.add_constraint(cs);
	    continue;
	}

	Linear_Expression le;
	for ( unsigned j = 0; j < known_param_list.params.size(); j++) {
	    le += atof (known_param_list.params[j].value.c_str()) * 
		update.find(known_param_list.params[j].name);
	}
	for ( int j = 0; j < dim; j++) {
	    le += Vars[j] * update.find(var_list.vars[j]);
	}
	le += update.get_cons();

	cs = (Vars[i2] == le);
	cvx.add_constraint(cs);

    }

    cvx.remove_space_dimensions(vs);
}

void Model::update_cvx(const EDGE &edge, NNC_Polyhedron &cvx) {

  
    int dim = var_list.vars.size();
  
    const EDGE *it = &edge;
  
    vector<Variable> Vars;
    for ( int i = 0; i <= dim; i++)
	Vars.push_back(Variable(i));

    int p, c;
    Variables_Set vs;

    for ( int i = 0; i < dim; i++) {

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

	if (!u_flag) {
	    continue;
	}

        if ( i < dim/2) {
          cvx.unconstrain(Vars[i]);
          Constraint cs1 = (Vars[i] == 0);
          cvx.add_constraint(cs1);
          i = dim/2 - 1;

          continue;
	}


        cvx.expand_space_dimension(Vars[i], 1);

        cvx.unconstrain(Vars[i]);

	Linear_Expression le;
	for ( unsigned j = 0; j < known_param_list.params.size(); j++) {
	    le += atof (known_param_list.params[j].value.c_str()) * 
		update.find(known_param_list.params[j].name);
	}
	for ( int j = dim; j <= dim; j++) {
	    le += Vars[j] * update.find(var_list.vars[i]);
	}
	le += update.get_cons();

	Constraint cs2 = (Vars[i] == le);
	cvx.add_constraint(cs2);


        cvx.remove_higher_space_dimensions(dim);
        return;

    }
  
}

NNC_Polyhedron Model::time_elapse_cvx(const Location *l) {
  
  
    int dim = var_list.vars.size();
    NNC_Polyhedron cvx (dim);
  
    vector<Variable> Vars;
    for (int i = 0; i < dim; i++)
	Vars.push_back(Variable(i));

    // time elapse
    for ( int i = 0; i < dim; i++) {
	int i_co = l->rate.find(var_list.vars[i]);
    
	Constraint cs = (Vars[i] == i_co);
	cvx.add_constraint(cs);
    }
  
    return cvx;

}

void Model::time_elapse_cvx(const Location *l, NNC_Polyhedron &cvx) {
  
  
    int dim = var_list.vars.size();
  
    vector<Variable> Vars;
    for (int i = 0; i < 2*dim + 1; i++)
	Vars.push_back(Variable(i));

    cvx.add_space_dimensions_and_embed(dim+1);

    // invar => time elapse
    Constraint cs = (Vars[dim] >= 0);	
    cvx.add_constraint(cs);
  
    Variables_Set vs;
    for ( int i = 0; i < dim; i++) {
	int i2 = i + dim + 1;
	int i_co = l->rate.find(var_list.vars[i]);
    
	Constraint cs = (Vars[i] + i_co * Vars[dim] == Vars[i2]);
	cvx.add_constraint(cs);
        vs.insert(Vars[i]);
    }

    vs.insert(Vars[dim]);
    cvx.remove_space_dimensions(vs);

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
    //int dim = 2*num_v + num_p + 1;
  
    vector<Variable> Vars;
    int total = 0;
    for (int i = 0; i < num_p; i++)
	Vars.push_back(Variable(total++));
    for (int i = 0; i < num_v; i++)
	Vars.push_back(Variable(total++));

    // invariant
    for ( vector<EXPR>::const_iterator it = l->invar.begin(); it != l->invar.end(); it++) {
	Linear_Expression le;
	for ( int i = 0; i < num_p; i++) {
	    le += Vars[i] * it->find(param_list.params[i].name);
	}
	for ( unsigned i = 0; i < known_param_list.params.size(); i++) {
	    le += atof (known_param_list.params[i].value.c_str()) *
		it->find(known_param_list.params[i].name);
	}
	for ( int i = 0; i < num_v; i++) {
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
	for ( int i = 0; i < num_p; i++) {
	    le += Vars[i] * it->find(param_list.params[i].name);
	}
	for ( unsigned i = 0; i < known_param_list.params.size(); i++) {
	    le += atof (known_param_list.params[i].value.c_str()) * 
		it->find(known_param_list.params[i].name);
	}
	for ( int i = 0; i < num_v; i++) {
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
    //int dim = 2*num_v + num_p + 1;
  
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
	for ( int i = 0; i < num_p; i++) {
	    le += Vars[i] * iit->find(param_list.params[i].name);
	}
	for ( unsigned i = 0; i < known_param_list.params.size(); i++) {
	    le += atof (known_param_list.params[i].value.c_str()) * 
		iit->find(known_param_list.params[i].name);
	}
	for ( int i = 0; i < num_v; i++) {
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
	for ( int j = 0; j < num_p; j++) {
	    le += Vars[j] * update.find(param_list.params[j].name);
	}
	for ( unsigned j = 0; j < known_param_list.params.size(); j++) {
	    le += atof (known_param_list.params[j].value.c_str()) * 
		update.find(known_param_list.params[j].name);
	}
	for ( int j = 0; j < num_v; j++) {
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

bool Model::contained_in( map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &m, 
   const shared_ptr<pair_sc> & sc, bool opt, bool debug) {

  for( auto iitm = m.cbegin(); iitm != m.cend(); iitm ++) {

          if (sc->signature != (sc->signature | iitm->first)) continue;

	  for ( auto il = iitm->second->begin(); il != iitm->second->end(); il++) { 
	      if( (*il)->contains(sc, fpfp_sim))
		      return true;	    
          }
  }

  if ( !opt) return false;

  for( auto iitm = m.begin(); iitm != m.end(); iitm ++) {

          if (iitm->first != (sc->signature | iitm->first)) continue;

          auto ed = iitm->second;

	  //for ( unsigned i = 0; i < ed->size(); i++) { 
	  for ( auto il = ed->begin(); il != ed->end(); il++) { 
              if ( ! (*il)->valid) {
                if (!debug)
                  ed->erase(il++);
                continue;
              }
	      if( sc->contains(*il, fpfp_sim)) {
                (*il)->clean_children();
                if (debug)
                  (*il)->valid = false;
                else
                  ed->erase(il++);
              }
	  }
  }
  return false;
}

void Model::insert_into(map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &m, const shared_ptr<pair_sc> &sc) {

  auto v = m.find(sc->signature)->second;

  v->push_back(sc);
}

static int count(int sig, int n) {
  int c = 0;
  for ( int i = 1; i <= n; i++)
    if ((sig & (unsigned)pow(2,i-1)) != 0) c++;
  return c;
}

bool Model::constrain_release1(const Location *l1) {

  if ( count(l1->signature, N) < cpus) return true;
  return false;
}

bool Model::constrain_release2(const shared_ptr<pair_sc> & sc) {

  int total = count(sc->signature, N);
  int now = 0;
  for (int i = 1; i < N ; i++) {
    if ( (sc->signature & (unsigned)pow(2,i-1)) == 0)
      continue;
    NNC_Polyhedron cvx = sc->cvx;
    Variable v(i-1);
    Constraint cs = ( v == 0 );
    cvx.add_constraint(cs);
    if ( ! cvx.is_empty())
      now ++;
  }

  if ( total - now >= cpus) return true; 

  return false;
}

bool Model::busy_period(unsigned sig) {
  return (sig & (unsigned)pow(2,N-1)) != 0 && count(sig,N)>cpus;
}

bool Model::forward_release(const shared_ptr<pair_sc>& state, unsigned ti) {

  if (state->tk_new)  return false;

  Variable v(ti-1);

  NNC_Polyhedron poly = state->cvx;

  // current state contains p_i == T_i
  Constraint cs = ( v == atoi(known_param_list.params[3*(ti-1)].value.c_str()));
  poly.add_constraint(cs);
  if( ! poly.is_empty())
    return false;

  // ti arrived earlier

  shared_ptr<pair_sc> origin = state->prior;
  bool idle_flag = false;

  while( origin != nullptr) {
    if ( ! origin->valid) return true;

    if (busy_period(origin->signature)) {
      poly = origin->cvx;
      Constraint cs = ( v == atoi(known_param_list.params[3*(ti-1)].value.c_str()));
      poly.add_constraint(cs);
      if ( ! poly.is_empty())
        return true;

      if (origin->tk_new) 
        break;
        
    }
    else {
      poly = origin->cvx;
      Constraint cs = ( v == atoi(known_param_list.params[3*(ti-1)].value.c_str()));
      poly.add_constraint(cs);
      if ( ! poly.is_empty()) {
        if (idle_flag)  { 
          //cout << " release not in latest idle period\n"; 
          return true;
        }

        idle_flag = true;
        vector<Variable> vs;
        for ( int i = 1; i < N; i++) 
          if ( (origin->signature & (unsigned)pow(2, i-1)) ==0 && (state->signature & (unsigned)pow(2, i-1)) !=0)
                  vs.push_back(Variable(i-1));
        poly = state->cvx;
        for (int i = 0; i < vs.size(); i++) {
          cs = (vs[i]==0);
          poly.add_constraint(cs);
          if (poly.is_empty()){ 
            //cout << " release in latest idle period\n"; 
            return true;
          }
        }

      }
    }
      

    origin = origin->prior;
  }

  //ti arrived before tk
  vector<Variable> vs;
  for ( int i = 1; i < N; i++) 
    if ( (origin->prior->signature & (unsigned)pow(2, i-1)) ==0 && (state->signature & (unsigned)pow(2, i-1)) !=0)
            vs.push_back(Variable(i-1));
  poly = state->cvx;
  for (int i = 0; i < vs.size(); i++) {
    cs = (vs[i]==0);
    poly.add_constraint(cs);
    if (poly.is_empty()){ 
      //cout << " release before tk arrives\n"; 
      return true;
    }
  }

  return false;
}

static int size(const map<unsigned int, shared_ptr<list<shared_ptr<pair_sc> > > > &m);

void Model::forward_a_step() {

  int K = 0;
  for( auto itm = passing_map.rbegin(); itm != passing_map.rend(); itm ++) {

    auto ing = itm->second;

    for (auto il = ing->begin(); il != ing->end(); il++) {
        if ( ! (*il)->valid) continue;
	//
	Location *l = com->get_a_location((*il)->label);
    
        if ( K % 500 == 0)
          cout << "  K = " << K << ", " << l->name << endl;
        K ++;

	for ( vector <EDGE>::const_iterator it = l->outgoing.begin(); 
	      it != l->outgoing.end(); it++) {
            
            if ( ! (*il)->valid) break;

	    Location *tmp = com->get_a_location(it->dest);
            
            if( ci) {
              if ( (l->signature & (unsigned)pow(2,N-1)) == 0 && (tmp->signature & (unsigned)pow(2, N-1)) != 0) {
                if ( constrain_release1(l)) {
                  continue;
                }
                if ( count(l->signature, N) != cpus) continue;
                if ( constrain_release2(*il)) {
                  continue;
                }
              }
              else if ( (l->signature & (unsigned)pow(2,N-1)) != 0 && (tmp->signature & (unsigned)pow(2,N-1))==0
                  && !tmp->is_bad)
                continue;
            }

            if (bp) {

              // now, let's consider the busy period while tk is waiting
              if ( (l->signature & (unsigned)pow(2,N-1)) != 0 && count(tmp->signature,N) > count(l->signature,N)
                  && count(l->signature,N)>cpus) {
                int ti = 0;
                for (int h = 1; h < N; h++)
                  if ( (l->signature & (unsigned)pow(2,h-1)) == 0 && (tmp->signature & (unsigned)pow(2, h-1)) != 0) {
                    ti = h;
                    break;
                  }
                //cout << "before judgement " << (*il)->label << "-" << tmp->name << endl;
                if ( forward_release(*il, ti)) {
                  //cout << (*il)->label << "-" << tmp->name << endl;
                  continue;
                }
              }

            }

	    NNC_Polyhedron poly = (*il)->cvx;
            guard_cvx(*it, poly);
	    if( poly.is_empty()) continue;
	    update_cvx(*it, poly);
      
            invar_cvx(tmp, poly);
	    if( poly.is_empty()) continue;
            poly.time_elapse_assign(tmp->time_elapse);
            invar_cvx(tmp, poly);
            
	    if( poly.is_empty()) continue;

	    if( type==FAST_REACH && tmp->is_bad) {

		pair_sc sc(it->dest,poly, known_param_list, tmp->signature);
		//sc.pre = passing[k].state;
		//next.push_back(sc);
		cout << "The target is reached. Fast saving ...\n";
		//fast_save();
		throw 0;
	    }


	    auto sc = make_shared<pair_sc>(it->dest, poly, known_param_list, tmp->signature);
            if ( (l->signature & (unsigned)pow(2,N-1)) == 0 && (tmp->signature & (unsigned)pow(2, N-1)) != 0)
              sc->tk_new = true;

            if (contained_in(passing_map, sc, op, true)) continue;
            if (contained_in(next_map, sc, true, false)) continue;
            if (contained_in(passed_map, sc, op, false)) continue;
            (*il)->add_a_child(sc);
            insert_into(next_map, sc);
            sc->prior = (*il);
        }
    }
  }
}
    
void Model::restore_bad_paths(NNC_Polyhedron poly)
{
    vector<NNC_Polyhedron> tmp = bad_paths;
    bad_paths.clear();
    for ( unsigned i = 0; i < tmp.size(); i++) {
        if( poly.contains(tmp[i]))  continue;
        if( tmp[i].contains(poly)) {
            for ( unsigned j = i; j < tmp.size(); j++)
                bad_paths.push_back(tmp[j]);
            return;
        }
        bad_paths.push_back(tmp[i]);
    }
    bad_paths.push_back(poly);
}

// static void clean_pair_sc_v_partial_order(vector<pair_sc> &v, 
// 					  int n=numeric_limits<int>::max()) {
//     unsigned k = 0;
//     while (k < v.size()) {
// 	int s = v.size();
// 	bool flag = true;
// 	int ub = s-k-1;
// 	if (s-n-1 > 0)
// 	    ub = s-n-1;
// 	for ( int j = 0; j < ub; j++) {
// 	    if (!v[s-k-1].contains(v[j]))
// 		continue;
// 	    //cout << "Got one!\n";
// 	    for (int r = j; r < s-1; r++)
// 		v[r] = v[r+1];
// 	    v.pop_back();
// 	    flag = false;
// 	    break;
// 	}
// 	if (flag) k++;
// 	if (k > n) 
// 	    return;
//     }
// }

// static void clean_pair_sc_v(vector<pair_sc> &v,
// 			    int n=numeric_limits<int>::max()) {

//     int K = v.size();
//     int ub = K - 1;
//     if ( K-n-1 >= 0)
// 	ub = K - n - 1;
//     for ( int i = 0; i <= ub; i++) {
//         if ( !v[i].valid)
// 	    continue;
//         for ( int j = K-n; j < K; j++) {
//             if( v[j].contains(v[i])) {
//                 pair_sc psc(v[i]);
//                 psc.valid=false;
//                 v[i]=psc;
//                 break;
//             }
//         }
//     }
// }

void Model::fast_save() {
    for ( unsigned i = 0; i < passing.size(); i++)
	if (passing[i].valid)
	    passed.push_back(passing[i]);
    //clean_pair_sc_v(passed, passing.size());

    //clean_pair_sc_v_partial_order(next);
    for ( unsigned i = 0; i < next.size(); i++)
	if (next[i].valid)
	    passed.push_back(next[i]);
    //clean_pair_sc_v(passed, next.size());
}

void Model::from_a_2_b(map<unsigned int, shared_ptr<list<shared_ptr<pair_sc> > > > &a, 
    map<unsigned int, shared_ptr<list<shared_ptr<pair_sc> > > > &b) {

  for( auto it = a.begin(); it != a.end(); it ++) {
          if (it->second->size() == 0) continue;

          auto de = b.find(it->first)->second;
          auto itpos = de->end();
          de->splice(itpos, *(it->second));

  }
}

static int size(const map<unsigned int, shared_ptr<list<shared_ptr<pair_sc> > > > &m) {
  int s = 0;
  for( auto iitm = m.cbegin(); iitm != m.cend(); iitm ++)
    s += iitm->second->size();
  return s;
}
void Model::sat() {

    if (! bp) {
      for( auto it = passing_map.begin(); it != passing_map.end(); it ++)
        for( auto iit = it->second->begin(); iit != it->second->end(); iit ++) {
          if ( !(*iit)->valid) {
            it->second->erase(iit++);
            continue;
          }
          (*iit)->empty();
        }
      for( auto it = next_map.begin(); it != next_map.end(); it ++)
        for( auto iit = it->second->begin(); iit != it->second->end(); iit ++) {
          if ( !(*iit)->valid) {
            it->second->erase(iit++);
          }
        }
    }
    //sat
    cout << "passing-" << size(passing_map) << endl;
    cout << "passed-" << size(passed_map) << endl;
    cout << "next-" << size(next_map) << endl;
    from_a_2_b(passing_map, passed_map);
    from_a_2_b(next_map, passing_map);
    cout << " Number of generated states: " << size(passing_map) << endl;
    cout << " Number of states passed: " << size(passed_map) << endl;
    cout << " ------------------------------------ \n";
}

void Model::bf_psy()
{
    int index = 0;
    cout << "step " << index++ << endl;
    NNC_Polyhedron base = base_cvx();
    invar_cvx(com->init, base);
    base.time_elapse_assign(com->init->time_elapse);
    invar_cvx(com->init, base);

    if (base.is_empty())  {
      cout << "Empty initial states\n";
      exit(0);
    }
     
    auto root = make_shared<pair_sc>(com->init->name, base, known_param_list,com->init->signature);
    passing_map.find(root->signature)->second->push_back(root);


    forward_a_step();

    while(size(next_map) != 0) {
	cout << " ------------------------------------ \n";
	cout << "step " << index++ << endl;
	sat();
	forward_a_step();
	cout << " ------------------------------------ \n";
    
    }
    cout << "The next is empty\n";
  
}

void Model::print_log(string lname)
{
    std::ofstream out(lname.c_str());
    streambuf *coutbuf = cout.rdbuf(); //save old buf
    cout.rdbuf(out.rdbuf()); //redirect std::cout to out.txt!

    for (unsigned i = 0; i < passed.size(); i++)
	passed[i].print();

    cout.rdbuf(coutbuf);
  
}

Automaton* composite(const Automaton *aton1, const Automaton *aton2)
{
    Automaton * aton = new Automaton();
    aton->name = aton1->name + aton2->name;

    for ( unsigned i = 0; i < aton1->locations.size(); i++) {
        for ( unsigned j = 0; j < aton2->locations.size(); j++) {
            Location *l = com_2_locs(aton1->locations[i], aton2->locations[j], aton1, aton2);
            aton->locations.push_back(l);
            if ( aton1->locations[i] == aton1->init && aton2->locations[j] == aton2->init)
                aton->init = l;
        }
    }
    for ( unsigned i = 0; i < aton1->synclabs.size(); i++)
        aton->synclabs.push_back(aton1->synclabs[i]);
    for ( unsigned i = 0; i < aton2->synclabs.size(); i++)
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

    for ( vector<EXPR>::const_iterator it = l1->invar.begin();
	 it != l1->invar.end(); ++it) 
        l->invar.push_back(*it);
    for ( vector<pair_ss>::const_iterator it = l1->rate.assign_atoms.begin();
	 it != l1->rate.assign_atoms.end(); ++it) 
        l->rate.assign_atoms.push_back(*it);
    for ( vector<EXPR>::const_iterator it = l2->invar.begin();
	 it != l2->invar.end(); ++it) 
        l->invar.push_back(*it);
    for ( vector<pair_ss>::const_iterator it = l2->rate.assign_atoms.begin();
	 it != l2->rate.assign_atoms.end(); ++it) 
        l->rate.assign_atoms.push_back(*it);
    
    for ( vector<EDGE>::const_iterator it = l1->outgoing.begin();
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
            for ( vector<EDGE>::const_iterator it2 = l2->outgoing.begin();
		 it2 != l2->outgoing.end(); it2++) {
                EDGE e;
                EDGE e2 = *it2;
                string slab2 = e2.sync;
                string next2 = e2.dest;
                if( slab1 == slab2) {
                    for ( vector<EXPR>::const_iterator iit = e1.guard.begin();
			 iit != e1.guard.end(); ++iit) 
                        e.guard.push_back(*iit);
                    //for( vector<pair_ss>::const_iterator iit = e1.ass.assign_atoms.begin();
                    //                iit != e1.ass.assign_atoms.end(); ++iit) 
                    //    e.ass.assign_atoms.push_back(*iit);
                    for ( vector<UPDATE>::const_iterator iit = e1.updates.begin();
			 iit != e1.updates.end(); ++iit) 
                        e.updates.push_back(*iit);
                    for ( vector<EXPR>::const_iterator iit = e2.guard.begin();
			 iit != e2.guard.end(); ++iit) 
                        e.guard.push_back(*iit);
                    //for ( vector<pair_ss>::const_iterator iit = e2.ass.assign_atoms.begin();
                    //                iit != e2.ass.assign_atoms.end(); ++iit) 
                    //    e.ass.assign_atoms.push_back(*iit);
                    for ( vector<UPDATE>::const_iterator iit = e2.updates.begin();
			 iit != e2.updates.end(); ++iit) 
                        e.updates.push_back(*iit);
    
                    e.sync = slab1;
                    e.dest = next1 + next2;
                    l->outgoing.push_back(e);
                    
                }
            }
        }
            
    }
    for ( vector<EDGE>::const_iterator it = l2->outgoing.begin();
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
//    for ( int i = 0; i < param_list1.params.size(); i++)
//        cout << param_list1.params[i].name << endl;
//    cout << "known_param_list1 :\n";
//    for ( int i = 0; i < known_param_list1.params.size(); i++)
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
