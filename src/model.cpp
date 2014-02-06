#include "model.hpp"
#include "unique_index.hpp"
#include <fstream>

int pair_sc::index = 0;

void time_elapse_assign(const std::vector<int>& v, Octagonal_Shape<int32_t> &os) {
  typedef typename OR_Matrix<int32_t>::row_iterator row_iterator;
  typedef typename OR_Matrix<int32_t>::row_reference_type row_reference;

  const dimension_type n_rows = os.matrix.num_rows();
  //const row_iterator m_begin = os.matrix.row_begin();
  //const row_iterator m_end = os.matrix.row_end();

  int32_t a = 1000;
  for (dimension_type i = 0; i < v.size(); i++) {
    int rate_i = v[i];
    int rate_ii = -v[i];
    const dimension_type di = 2*i;
    //row_reference x_i = *(m_begin + di);
    //row_reference x_ii = *(m_begin + (di + 1));

    for (dimension_type j = 0; j < v.size(); j++) {
      int rate_j = v[j];
      int rate_jj = -v[j];
      const dimension_type dj = 2*j;
      if (rate_j - rate_i > 0 && di >= dj){
      //if (di >= dj){
        assign_r(os.matrix[di][dj], PLUS_INFINITY, ROUND_NOT_NEEDED);
        //cout << "a=" << a << endl;
        //assign_r(os.matrix[di][dj], a++, ROUND_NOT_NEEDED);
        //cout << "<" << di << "," << dj << ">" << endl;
        //cout << os.matrix << endl;
      }
      if (rate_jj - rate_i > 0 && (di>=dj+1 || di+1==dj+1)){
      //if ((di>=dj+1 || di+1==dj+1)){
        assign_r(os.matrix[di][dj+1], PLUS_INFINITY, ROUND_NOT_NEEDED);
        //cout << "a=" << a << endl;
        //assign_r(os.matrix[di][dj+1], a++, ROUND_NOT_NEEDED);
        //cout << "<" << di << "," << dj+1 << ">" << endl;
        //cout << os.matrix << endl;
      }
      if (rate_j - rate_ii > 0 && (di+1>=dj || di==dj) ){
      //if ((di+1>=dj || di==dj) ){
        assign_r(os.matrix[di+1][dj], PLUS_INFINITY, ROUND_NOT_NEEDED);
        //cout << "a=" << a << endl;
        //assign_r(os.matrix[di+1][dj], a++, ROUND_NOT_NEEDED);
        //cout << "<" << di+1 << "," << dj << ">" << endl;
        //cout << os.matrix << endl;
      }
      if (rate_jj - rate_ii > 0 && (di+1>=dj+1) ){
      //if ((di+1>=dj+1) ){
        assign_r(os.matrix[di+1][dj+1], PLUS_INFINITY, ROUND_NOT_NEEDED);
        //cout << "a=" << a << endl;
        //assign_r(os.matrix[di+1][dj+1], a++, ROUND_NOT_NEEDED);
        //cout << "<" << di+1 << "," << dj+1 << ">" << endl;
        //cout << os.matrix << endl;
      }
    }

  }
  os.strong_coherence_assign();
  os.strong_closure_assign();
  //cout << "*************" << endl;
  //cout << os.matrix << endl;
}
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
    merge = false;
    frag = false;
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
        (*it)->elapse = elapse(*it);
        (*it)->time_elapse = time_elapse(*it);
        (*it)->time_elapse_cvx = time_elapse_cvx(*it);

        passed_map[(*it)->signature] = make_shared< list<shared_ptr<pair_sc> > > ();
        passing_map[(*it)->signature] = make_shared< list<shared_ptr<pair_sc> > > ();
        next_map[(*it)->signature] = make_shared< list<shared_ptr<pair_sc> > > ();
    }

    N = var_list.vars.size() / 2;
    /** 
     * for now, let's focus on reachability analysis
     **/
    //ff_poly = Octagonal_Shape<int32_t>(0, EMPTY);
    //line = 0;
}

Model::~Model()
{
    for (unsigned i = 0; i < automata.size(); i++)
	delete automata[i];
}

C_Polyhedron Model::base_cvx0() {
  
  int dim = var_list.vars.size();
  
  C_Polyhedron poly(dim);
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

Octagonal_Shape<int32_t> Model::base_cvx() {
  
  int dim = var_list.vars.size();
  
  Octagonal_Shape<int32_t> poly(dim);
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

void Model::invar_cvx(const Location *l, Octagonal_Shape<int32_t> &cvx) {
  
    int dim = var_list.vars.size();
    //Octagonal_Shape<int32_t> cvx(dim);
  
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

void Model::invar_cvx(const Location *l, C_Polyhedron &cvx) {
  
    int dim = var_list.vars.size();
    //Octagonal_Shape<int32_t> cvx(dim);
  
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
void Model::guard_cvx(const EDGE &edge, Octagonal_Shape<int32_t> &cvx) {
  
    int dim = var_list.vars.size();
  
    const EDGE *it = &edge;
    //Octagonal_Shape<int32_t> cvx(dim);
  
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

void Model::guard_cvx(const EDGE &edge, C_Polyhedron &cvx) {
  
    int dim = var_list.vars.size();
  
    const EDGE *it = &edge;
    //Octagonal_Shape<int32_t> cvx(dim);
  
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
void Model::update_cvx2(const EDGE &edge, Octagonal_Shape<int32_t> &cvx) {

  
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

void Model::update_cvx(const EDGE &edge, Octagonal_Shape<int32_t> &cvx) {

  
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

void Model::update_cvx(const EDGE &edge, C_Polyhedron &cvx) {

  
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

vector<int> Model::elapse(const Location *l) {
  
  
    vector<int> v; 
    // time elapse
    for ( int i = 0; i < var_list.vars.size(); i++) {
	int i_co = l->rate.find(var_list.vars[i]);
    
        v.push_back(i_co);
    }
  
    return v;

}

Octagonal_Shape<int32_t> Model::time_elapse(const Location *l) {
  
  
    int dim = var_list.vars.size();
    Octagonal_Shape<int32_t>  cvx (dim);
  
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

C_Polyhedron Model::time_elapse_cvx(const Location *l) {
  
  
    int dim = var_list.vars.size();
    C_Polyhedron cvx (dim);
  
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

void Model::time_elapse_cvx(const Location *l, Octagonal_Shape<int32_t> &cvx) {
  
  
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

Octagonal_Shape<int32_t> Model::location_cvx(const Location *l, const Octagonal_Shape<int32_t> *pre_cvx) {
  
    // a path leading to "target" is found
    if( l->is_bad && type != REACH) {

	if ( type == FAST_REACH) {
	    //cout << "The target location is reached\n";
	    //return Octagonal_Shape<int32_t>(0, EMPTY);
	    //exit (0);
	    fast_reach = true;
	}
	else {
	    Octagonal_Shape<int32_t> bad = *pre_cvx;
	    bad.remove_higher_space_dimensions(param_list.params.size());
	    //if (bad.is_empty()) 
	    //return Octagonal_Shape<int32_t>(0, EMPTY);
	    restore_bad_paths(bad);
	    return Octagonal_Shape<int32_t>(0, EMPTY);
	}

    }
  
    Octagonal_Shape<int32_t> cvx (*pre_cvx);
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

Octagonal_Shape<int32_t> Model::edge_cvx(const EDGE &edge, const Octagonal_Shape<int32_t> &pre_poly) {
  
    int num_p = param_list.params.size();
    int num_v = var_list.vars.size();
    //int dim = 2*num_v + num_p + 1;
  
    const EDGE *it = &edge;
    Octagonal_Shape<int32_t> cvx = pre_poly;
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
   const shared_ptr<pair_sc> & sc, bool opt) {

  for( auto iitm = m.cbegin(); iitm != m.cend(); iitm ++) {

          if (iitm->first != (sc->signature | iitm->first)) continue;

	  for ( auto il = iitm->second->begin(); il != iitm->second->end(); il++) { 
            
              //if ( ! (*il)->valid ) continue;
              if (  (*il)->reach_dm ) {
                continue;
              }
              
	      if( (*il)->contains(sc, fpfp_sim)) {
                (*il)->holds.push_back(sc);
		return true;	    
              }

              //if ( sc->signature == iitm->first && m == next_map &&  merge) {

              //  Octagonal_Shape<int32_t> p_hull = sc->cvx;
              //  if ( ! p_hull.upper_bound_assign_if_exact((*il)->cvx))
              //    continue;
              //  Octagonal_Shape<int32_t> tmp = p_hull;
              //  p_hull.difference_assign(sc->cvx);
              //  p_hull.difference_assign((*il)->cvx);
              //  if (p_hull.is_empty()) {
              //    //cout << " merge works in next\n";
              //    (*il)->cvx = tmp;
              //    (*il)->widen();
              //    return true;
              //  }

              //}

          }
  }

  //if (frag && m == next_map) {
  //  Octagonal_Shape<int32_t> poly = sc->widened_cvx;
  //  for( auto iitm = m.cbegin(); iitm != m.cend(); iitm ++) {

  //          //if (sc->signature != (sc->signature | iitm->first)) continue;
  //          if (sc->signature != iitm->first) continue;

  //    	    for ( auto il = iitm->second->begin(); il != iitm->second->end(); il++) { 
  //              if ( (*il)->widened_cvx.contains(poly))  {
  //                string tab;
  //                if ( m == passed_map) tab = "passed";
  //                if ( m == passing_map) tab = "passing";
  //                if ( m == next_map) tab = "next";
  //                //cout << "fragmentation works in " << tab << "\n";
  //                return true;
  //              }
  //              
  //              //if ( ! poly.poly_hull_assign_if_exact((*il)->widened_cvx))
  //              //  continue;
  //              //poly.poly_difference_assign((*il)->widened_cvx);

  //              Octagonal_Shape<int32_t> inter = poly;
  //              inter.intersection_assign((*il)->widened_cvx);
  //              if (inter.is_empty())
  //                continue;
  //              poly.poly_difference_assign(inter);

  //          }
  //  }
  //}
              
  if ( !opt) return false;

  for( auto iitm = m.begin(); iitm != m.end(); iitm ++) {

          if (sc->signature != (sc->signature | iitm->first)) continue;

          auto ed = iitm->second;

	  //for ( unsigned i = 0; i < ed->size(); i++) { 
	  for ( auto il = ed->begin(); il != ed->end(); il++) { 
              //if ( ! (*il)->valid) {
              //  if ( m != passing_map)
              //    ed->erase(il++);
              //  continue;
              //}
	      if( sc->contains(*il, fpfp_sim)) {
                sc->holds.push_back(*il);
                
                //(*il)->clean_children();
                //if ( m == passing_map)
                //  (*il)->valid = false;
                //else
                ed->erase(il++);
              }
	  }
  }
  return false;
}

void Model::insert_into(map<unsigned int, shared_ptr<list< shared_ptr<pair_sc> > > > &m, const shared_ptr<pair_sc> &sc) {

  //if ( ! (merge && m == passed_map) ) {
    auto v = m.find(sc->signature)->second;
    v->push_back(sc);
    return;
  //}

  //for( auto iitm = m.cbegin(); iitm != m.cend(); iitm ++) {

  //        if (sc->signature != (sc->signature | iitm->first)) continue;

  //        for ( auto il = iitm->second->begin(); il != iitm->second->end(); il++) { 
  //            
  //            Octagonal_Shape<int32_t> p_hull = sc->widened_cvx;
  //            if ( ! p_hull.poly_hull_assign_if_exact((*il)->widened_cvx))
  //              continue;
  //            Octagonal_Shape<int32_t> tmp = p_hull;
  //            p_hull.poly_difference_assign(sc->widened_cvx);
  //            p_hull.poly_difference_assign((*il)->widened_cvx);
  //            if (p_hull.is_empty()) {
  //              cout << " merge works in passed\n";
  //              (*il)->widened_cvx = tmp;
  //              return;
  //            }

  //        }
  //}
  //auto v = m.find(sc->signature)->second;
  //v->push_back(sc);

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
    Octagonal_Shape<int32_t> cvx = sc->cvx;
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

  Octagonal_Shape<int32_t> poly = state->cvx;

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

bool Model::already_in_the_path(shared_ptr<State> & ss)
{
  auto p = ss->prior;
  while ( p != nullptr)
  {
    if (p->label == ss->label && p->exact_cvx.contains(ss->exact_cvx))// && ss->cvx.contains(p->cvx))
      return true;
    p = p->prior;
  }
  return false;
}

static void print_states(shared_ptr<State> & ss)
{
  vector<shared_ptr<State> > route;
  auto p = ss;
  while ( p!= nullptr) {
    route.push_back(p);
    p = p->prior;
  }
  for ( auto it = route.rbegin(); it != route.rend(); it++)
    cout << (*it)->label << " => ";
}

bool Model::depth_first(shared_ptr<State> & starter, int depth)
{
  cout << "depth : " << depth << endl;
  Location *l = com->get_a_location(starter->label);
  for ( vector <EDGE>::const_iterator it = l->outgoing.begin(); it != l->outgoing.end(); it++) {
    //cout << starter->label << " => " << it->dest << endl;
    //print_states(starter); cout << it->dest << endl;
    
    Location *tmp = com->get_a_location(it->dest);
    Octagonal_Shape<int32_t> poly = starter->cvx;
    C_Polyhedron exact_poly = starter->exact_cvx;
    guard_cvx(*it, poly);
    guard_cvx(*it, exact_poly);
    if( poly.is_empty()) continue;
    update_cvx(*it, poly);
    update_cvx(*it, exact_poly);
      
    invar_cvx(tmp, poly);
    invar_cvx(tmp, exact_poly);
    if( poly.is_empty()) continue;
    poly.strong_closure_assign();
    time_elapse_assign(tmp->elapse, poly);
    exact_poly.time_elapse_assign(tmp->time_elapse_cvx);
    invar_cvx(tmp, poly);
    invar_cvx(tmp, exact_poly);
    if( poly.is_empty()) continue;

    auto sc = make_shared<pair_sc>(it->dest, poly, known_param_list, tmp->signature);
    sc->prior = starter;
    sc->prior_edge = *it;
    sc->exact_cvx = exact_poly;

    if (contained_in(passed_map, sc, false))
      continue;
    if ( already_in_the_path(sc)) continue;

    if ( tmp->is_bad){
      starter->reach_dm = true;
      auto p = starter->prior;
      while ( p != nullptr) {
        if ( p->reach_dm) break;
        p->reach_dm = true;
        p = p->prior;
      }
      if ( !sc->exact_cvx.is_empty())
        throw 0;
      else {cout << "false alarm " << endl; continue;}
    }

    depth_first(sc, depth + 1);
  }
  if ( ! starter->reach_dm){
    if (contained_in(passed_map, starter, true)) return false; 
  }
  else{
    if (contained_in(passed_map, starter, false)) return false; 
  }
  insert_into(passed_map, starter);

  cout << " size of passed map : " << size (passed_map) << endl;
  return starter->reach_dm;
 
}

void Model::forward_a_step() {

  int K = 0;
  for( auto itm = passing_map.rbegin(); itm != passing_map.rend(); itm ++) {

    auto ing = itm->second;

    for (auto il = ing->begin(); il != ing->end(); il++) {
        if ( ! (*il)->valid) continue;
        if ( (*il)->reach_dm) continue;
	//
	Location *l = com->get_a_location((*il)->label);
    
        if ( K % 500 == 0)
          cout << "  K = " << K << ", " << l->name << endl;
        K ++;

	for ( vector <EDGE>::const_iterator it = l->outgoing.begin(); 
	      it != l->outgoing.end(); it++) {
            
            if ( ! (*il)->valid) break;
            if ( (*il)->reach_dm) continue;

	    Location *tmp = com->get_a_location(it->dest);
            

	    Octagonal_Shape<int32_t> poly = (*il)->cvx;
            C_Polyhedron exact_poly = (*il)->exact_cvx;
            guard_cvx(*it, poly);
            guard_cvx(*it, exact_poly);
	    if( poly.is_empty()) continue;
	    //if( exact_poly.is_empty()) continue;
	    update_cvx(*it, poly);
	    update_cvx(*it, exact_poly);
      
            invar_cvx(tmp, poly);
            invar_cvx(tmp, exact_poly);
	    if( poly.is_empty()) continue;
	    //if( exact_poly.is_empty()) continue;
            poly.strong_closure_assign();
            //poly.time_elapse_assign(tmp->time_elapse);
            exact_poly.time_elapse_assign(tmp->time_elapse_cvx);
            time_elapse_assign(tmp->elapse, poly);
            //poly.strong_closure_assign();
            invar_cvx(tmp, poly);
            invar_cvx(tmp, exact_poly);
            
	    if( poly.is_empty()) continue;
	    //if( exact_poly.is_empty()) continue;

	    auto sc = make_shared<pair_sc>(it->dest, poly, known_param_list, tmp->signature);
            sc->prior = (*il);
            sc->prior_edge = *it;
            sc->exact_cvx = exact_poly;
            sc->exact = true;
	    if( type==FAST_REACH && tmp->is_bad) {
                //if ( ! is_reachable(sc)) { 
                if ( sc->exact_cvx.is_empty()) {
                  cout << (*il)->label << " false alarm\n"; 
                  auto p = sc->prior;
                  while ( p!= nullptr) {
                    if ( p->reach_dm) break;
                    p->reach_dm = true;
                    //cout << p->label << endl;
                    cout << "size of holds " << p->holds.size() << endl;
                    for ( auto pt = p->holds.begin(); pt != p->holds.end(); pt++) {
                      if (contained_in(passing_map, *pt, false)) continue;
                      if (contained_in(next_map, *pt, true)) continue;
                      if (contained_in(passed_map, *pt, false)) continue;
                      cout << " not contained in \n";
                      insert_into(next_map, *pt);
                    }
                    p->holds.clear();
                    p = p->prior;
                  }
                  continue;
                }
		//pair_sc sc(it->dest,poly, known_param_list, tmp->signature);
		//sc.pre = passing[k].state;
		//next.push_back(sc);
		cout << "The target is reached. Fast saving ...\n";
		//fast_save();
		throw 0;
	    }


            if (already_in_the_path(sc)) continue;
            //if (contained_in(passing_map, sc, false)) continue;
            //if (contained_in(next_map, sc, true)) continue;
            if (contained_in(passed_map, sc, false)) continue;
            (*il)->add_a_child(sc);
            insert_into(next_map, sc);
        }
    }
  }
}

//static void release_holds(shared_ptr<State> ss) {
//    for ( auto pt = ss->holds.begin(); pt != ss->holds.end(); pt++) {
//      if (contained_in(passing_map, *pt, false)) continue;
//      if (contained_in(next_map, *pt, true)) continue;
//      if (contained_in(passed_map, *pt, false)) continue;
//      insert_into(next_map, *pt);
//    }
//    ss->holds.clear();
//}

bool Model::is_reachable(shared_ptr<State> last)
{
  list<shared_ptr<State> > route;
  route.insert(route.begin(),last);
  while(route.front()->prior != nullptr) {
    auto prior = route.front()->prior;
    route.insert(route.begin(), prior);
  }


  C_Polyhedron cvx = base_cvx0();

  for (auto it = route.begin(); it != route.end(); it++) {
    if( (*it)->reach_dm || (*it)->exact ) {
      cvx = (*it)->exact_cvx;
      continue;
    }
    if ( (*it)->prior != nullptr) {
      EDGE e = (*it)->prior_edge;
      guard_cvx(e, cvx);
      if (cvx.is_empty()) return false; //{(*it)->valid=false; (*it)->clean_children(); return false;}
      update_cvx(e, cvx);
    }
    Location * loc = com->get_a_location((*it)->label);
    invar_cvx(loc, cvx);
    if (cvx.is_empty()) return false; //{(*it)->valid=false; (*it)->clean_children(); return false;}
    cvx.time_elapse_assign(loc->time_elapse_cvx);
    invar_cvx(loc, cvx);
    if (cvx.is_empty()) return false; //{(*it)->valid=false; (*it)->clean_children(); return false;}
    (*it)->exact_cvx = cvx;
    (*it)->reach_dm = true;
    (*it)->exact = true;

  }

  return true;
}
    
void Model::build_exact_cvx(shared_ptr<State> last)
{
  list<shared_ptr<State> > route;
  route.insert(route.begin(),last);
  while(route.front()->prior != nullptr) {
    auto prior = route.front()->prior;
    route.insert(route.begin(), prior);
  }


  C_Polyhedron cvx = base_cvx0();

  for (auto it = route.begin(); it != route.end(); it++) {
    if( (*it)->exact || (*it)->reach_dm ) {
      cvx = (*it)->exact_cvx;
      continue;
    }
    if ( (*it)->prior != nullptr) {
      EDGE e = (*it)->prior_edge;
      guard_cvx(e, cvx);
      //if (cvx.is_empty()) {last->exact_cvx = cvx; return ;}
      update_cvx(e, cvx);
    }
    Location * loc = com->get_a_location((*it)->label);
    invar_cvx(loc, cvx);
    //if (cvx.is_empty()) {last->exact_cvx = cvx; return ;}
    cvx.time_elapse_assign(loc->time_elapse_cvx);
    invar_cvx(loc, cvx);
    //if (cvx.is_empty()) {last->exact_cvx = cvx; return ;}
    (*it)->exact_cvx = cvx;
    //(*it)->reach_dm = true;
    (*it)->exact = true;

  }
  last->exact_cvx = cvx;
  last->exact = true;
  return;
}

void Model::restore_bad_paths(Octagonal_Shape<int32_t> poly)
{
    vector<Octagonal_Shape<int32_t>> tmp = bad_paths;
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
          if ( (*iit)->tmp)
            it->second->erase(iit++);
          if ( !(*iit)->valid) {
            it->second->erase(iit++);
            continue;
          }
          //(*iit)->empty();
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

void Model::df()
{
    int index = 0;
    cout << "step " << index++ << endl;
    Octagonal_Shape<int32_t> base = base_cvx();
    invar_cvx(com->init, base);
    base.strong_closure_assign();
    //base.time_elapse_assign(com->init->time_elapse);
    time_elapse_assign(com->init->elapse, base);
    base.strong_closure_assign();
    invar_cvx(com->init, base);

    if (base.is_empty())  {
      cout << "Empty initial states\n";
      exit(0);
    }
     
    auto root = make_shared<pair_sc>(com->init->name, base, known_param_list,com->init->signature);
    root->exact_cvx = base_cvx0();

    depth_first(root);
}

void Model::bf_psy()
{
    int index = 0;
    cout << "step " << index++ << endl;
    Octagonal_Shape<int32_t> base = base_cvx();
    invar_cvx(com->init, base);
    base.strong_closure_assign();
    //base.time_elapse_assign(com->init->time_elapse);
    time_elapse_assign(com->init->elapse, base);
    base.strong_closure_assign();
    invar_cvx(com->init, base);

    if (base.is_empty())  {
      cout << "Empty initial states\n";
      exit(0);
    }
     
    auto root = make_shared<pair_sc>(com->init->name, base, known_param_list,com->init->signature);
    root->exact_cvx = base_cvx0();
    root->exact = true;
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

    for (auto it = passed_map.begin(); it != passed_map.end(); it++)
      for ( auto iit = it->second->begin(); iit != it->second->end(); iit++)
        (*iit)->print();

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
//	Octagonal_Shape<int32_t> cvx = base_cvx();
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
//    Octagonal_Shape<int32_t> poly;
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
//		Octagonal_Shape<int32_t> cvx = edge_cvx(edge, poly);
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
////    Octagonal_Shape<int32_t> poly = base_cvx();
////
////    for( vector<EDGE>::const_iterator it = path.e_path.begin();
////                    it != path.e_path.end(); it++) {
////       string dest = it->dest;
////       EDGE edge = *it;
////
////       Octagonal_Shape<int32_t> cvx = edge_cvx(edge, poly);
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
////    Octagonal_Shape<int32_t> poly = base_cvx();
////	
////	// The pre-unfeasible poly when there is only
////	// one edge.
////	if( path.e_path.size() == 1) {
////		Octagonal_Shape<int32_t> p = poly;
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
////       	Octagonal_Shape<int32_t> cvx = edge_cvx(edge, poly);
////
////       	poly = location_cvx(com->get_a_location(dest), &cvx);
////       	if( it == path.e_path.end() - 2) {
////       	    Octagonal_Shape<int32_t> p = poly;
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
//    //pair_sc sc("haha", Octagonal_Shape<int32_t>(2));
//    //pair_sc sc2("haha", Octagonal_Shape<int32_t>(2, EMPTY));
//    //v.push_back(sc2);
//    //v.push_back(sc2);
//    //v.push_back(sc);
//    //v.push_back(sc);
//    //v.push_back(sc);
//    //cout << " before clean " << v.size();
//    //clean_pair_sc_v(v);
//    //cout << " after clean " << v.size();
//}
