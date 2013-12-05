#ifndef _parser_hpp_
#define _parser_hpp_

#include <string>
#include <iostream>
#include <fstream>
#include <vector>
#include <utility>
#include <memory>
#include <cstdlib>

#include <boost/variant.hpp>
#include <boost/variant/recursive_variant.hpp>

#include <boost/spirit/include/phoenix_core.hpp>
#include <boost/spirit/include/phoenix_operator.hpp>
#include <boost/spirit/include/phoenix_fusion.hpp>
#include <boost/spirit/include/phoenix_stl.hpp>
#include <boost/spirit/include/qi.hpp>
#include <boost/spirit/include/phoenix_fusion.hpp>
#include <boost/spirit/include/phoenix_stl.hpp>
#include <boost/fusion/include/adapt_struct.hpp>
#include <boost/spirit/include/qi_int.hpp>
#include <boost/spirit/repository/include/qi_confix.hpp>
#include <boost/spirit/include/support_multi_pass.hpp>
#include <boost/spirit/include/classic_position_iterator.hpp>

// A help struct consisting of a pair of strings
struct pair_ss {
	std::string first;
	std::string second;
	pair_ss() {}
	pair_ss(std::string s1, std::string s2) {
		first = s1;
		second = s2;
	}
};

// Parsed continous variables are stored in a variable list
struct Var_list
{
	Var_list() {}
	std::vector<std::string> vars;

    // Return the index of variable "s" in the variable list;
	// return -1 if the input string does not match a variable name
    int find(const std::string s) const {
		for ( unsigned i = 0; i < vars.size(); i++)
			if( vars[i] == s) return i;
		return -1;
	}
};

// A parameter has a "name", and can be optionally given a initial domain
struct Param
{
	Param() : name(""), op(""), value(""){}
	std::string name;
	std::string op;
	std::string value;
};

// The parameter list. 
struct Param_list
{
	std::vector<Param> params;

	int find(const std::string s) const {
		for( unsigned i = 0; i < params.size(); i++)
			if( params[i].name == s) return i;
		return -1;
	}
};

// This naming is not accruate. This class actually represents a Linear Constraint
struct EXPR
{
	// the left part (linear expression): variables and their coefficients
	std::vector<pair_ss> expr_atoms;
	// the operator: <, <=, =, >= or >
	std::string op;
	// the left value
	std::string value;
	// to print the expression
	void print() const {
		for ( unsigned i = 0; i < expr_atoms.size(); i++)
			std::cout << expr_atoms[i].first << expr_atoms[i].second;
			std::cout << op << value;
	} 
	/**
	 *	Return the coefficient of a parameter or variable in
	 *	an expression. If the input variable or parameter is
	 * 	not in this expression, 0 is returned.
	 **/
	int find (const std::string s) const {
		for ( unsigned i = 0; i < expr_atoms.size(); i++) {
			if( expr_atoms[i].second == s) {
				return atof (expr_atoms[i].first.c_str()); 
			}
		}

		return 0;
	}
	
};

// The update statement in an edge
// Current ASSIGN only supports assigning an integer to a variable
// and the next step is to support update a variable with a linear expression  
struct ASSIGN {

    std::vector<pair_ss> assign_atoms;

    void print() const {
        for ( unsigned i = 0; i < assign_atoms.size(); i++) {
            std::cout << assign_atoms[i].first << "'=" << assign_atoms[i].second;
			if (i < assign_atoms.size()-1)
				std::cout << ", ";
		}
		std::cout << std::endl;
    }
    
    int find(const std::string s) const  {
      for ( unsigned i = 0; i < assign_atoms.size(); i++)
        if( assign_atoms[i].first == s)
          return atof(assign_atoms[i].second.c_str());
      // By default, the variable rate is 1
      return 1;
    }

};

// The update statement in an edge
struct UPDATE {

  std::string left;
  std::vector<pair_ss> right_atoms;    
  std::vector<std::string> cons; // the constant value

  // to print the expression
  void print() const {
    std::cout << left;
    std::cout << "'= ";
    for ( unsigned i = 0; i < right_atoms.size(); i++)
      std::cout << right_atoms[i].first << right_atoms[i].second;
    for ( unsigned i = 0; i < cons.size(); i++)
      std::cout << cons[i];
  }

  int get_cons() {
    if ( cons.size() == 0)
      return 0;
    int sum = 0;
    for ( unsigned i = 0; i < cons.size(); i++)
      sum += atof ( cons[i].c_str());
    return sum;
  }
    /**
	 *	Return the coefficient of a parameter or variable in
	 *	an expression. If the input variable or parameter is
	 * 	not in this expression, 0 is returned.
	 **/
	int find (const std::string s) const {
		for ( unsigned i = 0; i < right_atoms.size(); i++) {
			if( right_atoms[i].second == s) {
				return atof (right_atoms[i].first.c_str());
			}
		}
        
		return 0;
	}
	
};


// An edge in the PLHA
struct EDGE
{
    // the guard
    std::vector<EXPR> guard;
    // synchronization label
    std::string sync;
    // assignment function
    ASSIGN ass; // We are removing this field now
    std::vector<UPDATE> updates;
    // the name of destination location
    std::string dest;
   
    EDGE() { index = -1; }
	// an edge is identified by a unique index
	int index;
	// Two edges are the same if they share identical non-negative index
    bool equal(const EDGE &edge) {
        return edge.index == index && index >= 0;
    }
    void print() const {
      std::cout << "==>" << dest << "\n";
      for ( unsigned i = 0; i < guard.size(); i++) {      
        guard[i].print();
        if ( i < guard.size()-1)
          std::cout  << " & ";
        else
          std::cout << std::endl;
      }
      std::cout << "sync label: " << sync << std::endl;
      std::cout << "updates: "; 
      ass.print();
      for ( unsigned i = 0; i < updates.size(); i++) {
        updates[i].print();
        if ( i < updates.size()-1)
          std::cout  << ", ";
        else
          std::cout << std::endl;
      }
    }
};

// a location in the PLHA
struct LOCATION
{
	// location is indefied by the name
    std::string name;
	// invariant
    std::vector<EXPR> invar;
	// derivatives of variables
    ASSIGN rate;
	// outgoing edges
    std::vector<EDGE> outgoing;
	// is_bad = 1 if this location is bad
	bool is_bad;
    void print() const{
        std::cout << "state name : " << name << "\n";
		std::cout << "invariant : ";
        for ( unsigned i = 0; i < invar.size(); i++) {
            invar[i].print();
			if (i < invar.size()-1)
				std::cout  << " & ";
        }
		std::cout << std::endl;
		std::cout << "rates : ";
        rate.print();
        //std::cout << std::endl;
		std::cout << "edges : \n";
        for ( unsigned i = 0; i < outgoing.size(); i++)
            outgoing[i].print();
    }

};

// The parametric linear hybrid automaton
struct AUTOMATON {
	// automaton name
	std::string name;
	std::vector<LOCATION> locations;
	// the set of synchronization labels used in this automaton
	std::vector<std::string> synclabs;

	void print() const {
    	std::cout << "automaton name : " << name << std::endl;
		
    	for( unsigned i = 0; i < locations.size(); i++) {
			std::cout << "LOC<" << i << ">: \n";
    		locations[i].print();
		}
	}
};

// INIT specifies initial locations , initial constraints and bad locations.
struct INIT {
	// initial locations of each automaton
	std::vector<pair_ss> init;
	// initial constraints
	std::vector<EXPR> constraints;
	// bad locations
	std::vector<pair_ss > bads;

	void print() const {
		std::cout << std::endl;
		for( unsigned i = 0; i < init.size(); i++) {
			std::cout << init[i].first << "=" << init[i].second;
			if (i < init.size()-1) 
				std::cout << " & ";
		}
		//std::cout << std::endl;
		for( unsigned i = 0; i < constraints.size(); i++) {
			constraints[i].print();
			if (i < constraints.size()-1) 
				std::cout << " & ";
		}
		std::cout << std::endl;
		std::cout << "the target location :  ";
		for( unsigned i = 0; i < bads.size(); i++) {
			std::cout << bads[i].first << "=" << bads[i].second;
			if (i < bads.size()-1) 
				std::cout << " & ";
		}
		std::cout << std::endl;
	}
};

// The complete input model 
struct MODEL
{
	Var_list var_list;
	// This field should be removed
	Var_list reserved_var_list;
	Param_list param_list;
	// parameters used for inverse method with complete result
	Param_list im_param_list;
	std::vector<AUTOMATON> automaton_v;
	INIT init;
	
    MODEL() {}
	void print() {
		std::cout << "variables : ";
		for (unsigned i = 0; i < var_list.vars.size(); i++)
			std::cout << var_list.vars[i] << "  ";
		std::cout << std::endl; 
		std::cout << "parameters : ";
		for (unsigned i = 0; i < param_list.params.size(); i++) {
			std::cout << param_list.params[i].name;
			if (param_list.params[i].op != "")
				std::cout << param_list.params[i].op << param_list.params[i].value;
			std::cout << "  ";
		}
		std::cout << std::endl; 
		std::cout << "imcr parameters : ";
		for (unsigned i = 0; i < im_param_list.params.size(); i++) {
			std::cout << im_param_list.params[i].name;
			std::cout << "  ";
		}
		std::cout << std::endl; 
		std::cout << "initial declaration : ";
		init.print();
		std::cout << "********************* to output automata *****************\n";
		for( unsigned i = 0; i < automaton_v.size(); i++)
				automaton_v[i].print();
		std::cout << "********************* done *******************************\n";
	}

};

template<template <class, class> class Grammar, class DataType> 
bool myparse(std::istream& input, const std::string filename, DataType &result);
MODEL parse(char const* filename);

#endif
