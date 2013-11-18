#include "parser.hpp"

BOOST_FUSION_ADAPT_STRUCT(
	pair_ss,
	(std::string, first)
	(std::string, second)
)

BOOST_FUSION_ADAPT_STRUCT(
	EXPR,
	//(std::vector<Expr_atom>, expr_atoms)
	(std::vector<pair_ss>, expr_atoms)
	(std::string, op)
	(std::string, value)
)

BOOST_FUSION_ADAPT_STRUCT(
	ASSIGN,
	(std::vector<pair_ss>, assign_atoms)
)

BOOST_FUSION_ADAPT_STRUCT(
    UPDATE,
    (std::string, left)
    (std::vector<pair_ss>, right_atoms)
    (std::vector<std::string>, cons)
)

BOOST_FUSION_ADAPT_STRUCT(
	Param,
	(std::string, name)
	(std::string, op)
	(std::string, value)
)

BOOST_FUSION_ADAPT_STRUCT(
	Param_list,
	(std::vector<Param>, params)
)

BOOST_FUSION_ADAPT_STRUCT(
	Var_list,
	(std::vector<std::string>, vars)
)

BOOST_FUSION_ADAPT_STRUCT(
	EDGE,
	(std::vector<EXPR>, guard)
	(std::string, sync)
	//(ASSIGN, ass)
        (std::vector<UPDATE>, updates)
	(std::string, dest)
)

BOOST_FUSION_ADAPT_STRUCT(
	LOCATION,
	(std::string, name)
	(std::vector<EXPR>, invar)
	(ASSIGN, rate)
	(std::vector<EDGE>, outgoing)
)
BOOST_FUSION_ADAPT_STRUCT(
	AUTOMATON,
	(std::string, name)
	(std::vector<LOCATION>, locations)
	(std::vector<std::string>, synclabs)
)
BOOST_FUSION_ADAPT_STRUCT(
	INIT,
	(std::vector<pair_ss>, init)
	(std::vector<EXPR>, constraints)
	(std::vector<pair_ss>, bads)
)
BOOST_FUSION_ADAPT_STRUCT(
	MODEL,
	//(std::vector<MODEL::Element>, elements)
	(Var_list, var_list)
	(Var_list, reserved_var_list)
	(Param_list, param_list)
	(Param_list, im_param_list)
	(std::vector<AUTOMATON>, automaton_v)
	(INIT, init)
)

namespace qi = boost::spirit::qi;
namespace ascii = boost::spirit::ascii;
namespace fusion = boost::fusion;
namespace phoenix = boost::phoenix;

template <typename Iterator, typename Skipper>
struct Model_grammar : qi::grammar<Iterator, MODEL(), Skipper>
{
	qi::rule<Iterator, Var_list(), Skipper> var_list;
	qi::rule<Iterator, Var_list(), Skipper> reserved_var_list;
	qi::rule<Iterator, MODEL(), Skipper> model;
	qi::rule<Iterator, std::string(), Skipper> name;

	qi::rule<Iterator, Param_list(), Skipper> params;
	qi::rule<Iterator, Param_list(), Skipper> im_params;
	qi::rule<Iterator, Param(), Skipper> param;
	qi::rule<Iterator, std::string(), Skipper> op;
	qi::rule<Iterator, std::string(), Skipper> value;
	qi::rule<Iterator, std::string(), Skipper> value1;

	qi::rule<Iterator, EXPR(), Skipper> expr;
	qi::rule<Iterator, pair_ss(), Skipper> expr_atom;
	qi::rule<Iterator, std::string(), Skipper> co;

	qi::rule<Iterator, ASSIGN(), Skipper> assign;
	qi::rule<Iterator, pair_ss(), Skipper> assign_atom;
        
        qi::rule<Iterator, UPDATE(), Skipper> update;
        //qi::rule<Iterator, std::vector<UPDATE>, Skipper> updates;

	qi::rule<Iterator, EDGE(), Skipper> trans;
	qi::rule<Iterator, LOCATION(), Skipper> state;
	qi::rule<Iterator, AUTOMATON(), Skipper> automaton;
	qi::rule<Iterator, INIT(), Skipper> init;
	qi::rule<Iterator, pair_ss(), Skipper> ss;
//	qi::rule<Iterator, std::vector<pair_ss >(), Skipper> bads;

	Model_grammar() :
            Model_grammar::base_type(model, "To parse a LHA") {
		using qi::lit;
		using qi::alpha;
		using qi::alnum;
		using qi::lexeme;
		using qi::char_;
		using qi::space;
		using phoenix::at_c;
        using phoenix::push_back;
		using boost::spirit::qi::uint_;
		using boost::spirit::ascii::digit;
		using boost::spirit::eps;
		using boost::phoenix::val;
		using namespace qi::labels;

		//name = lexeme[+(alpha [_val += _1] >> *alnum	[_val += _1])];
		name = lexeme[+(alpha | alnum | char_('_'))	[_val += _1]];
		op = lexeme[ char_('=') [_val += _1]] |
				(lexeme[ ( char_('<') | char_('>') )[_val += _1]]
					>> -( lexeme[ char_('=') [_val += _1]]))
		;
		value = -lexeme[(char_('-') | char_('+')) [_val += _1] ] >> *alnum [_val += _1];
		value1 = -lexeme[(char_('-') | char_('+')) [_val += _1] ] >> +alnum [_val += _1];

		co = lexeme[ (char_('-') | char_('+')) [_val = _1]]; 
		expr_atom = 
				(co [at_c<0>(_val) = _1] 
				>> 	+digit [at_c<0>(_val) += _1]
				>>	name [at_c<1>(_val) = _1]) 
				|
				(co [at_c<0>(_val) = _1 + val("1")] 
				>>	name [at_c<1>(_val) = _1]) 
				|
				+digit [at_c<0>(_val) += _1]
				>>	name [at_c<1>(_val) = _1]
				|
				(name [at_c<1>(_val) = _1]) [at_c<0>(_val) = val("1") ]
		;
		expr =  
			 "True" |
			(+expr_atom [push_back(at_c<0>(_val), _1)]
			>>	op [at_c<1>(_val) = _1]
			>> -lexeme[(char_('-')|char_('+'))[at_c<2>(_val) += _1]]  
			>>  //value1 [at_c<2>(_val) = _1]
				+digit [at_c<2>(_val) += _1]
				//| value [at_c<2>(_val) = _1])
			)
		;

                update =  name [at_c<0>(_val) = _1] >> "'="
                    //>> +(expr_atom [push_back(at_c<1>(_val), _1)]
                      //| value[push_back(at_c<2>(_val), _1)])  
                    >> * expr_atom [push_back(at_c<1>(_val), _1)]
                    >> value[push_back(at_c<2>(_val), _1)]  
                ;

		assign_atom = name [at_c<0>(_val) = _1]
			>>	"'="
			//>> (name [at_c<1>(_val) = _1] | +digit [at_c<1>(_val) += _1])
			>> (name [at_c<1>(_val) = _1] | value [at_c<1>(_val) += _1])
		;
		assign = assign_atom [push_back(at_c<0>(_val), _1)]
					>> *( ',' >> assign_atom [push_back(at_c<0>(_val), _1)])
		;
                
	
		param = name [at_c<0>(_val) = _1] 
			>> -(op [at_c<1>(_val) = _1] >> value [at_c<2>(_val) = _1]);
		params = (param [push_back(at_c<0>(_val), _1)]) 
			>>	*(lit(',') >> param  [push_back(at_c<0>(_val), _1)])	
			>> lit(':') 
			>> *space 
			>> lit("parameter;");	
		im_params = (param [push_back(at_c<0>(_val), _1)]) 
			>>	*(lit(',') >> param  [push_back(at_c<0>(_val), _1)])	
			>> lit(':') 
			>> *space 
			>> lit("im_parameter;");	

		var_list = name [push_back(at_c<0>(_val), _1)]	
			>>	*(lit(',') >> name  [push_back(at_c<0>(_val), _1)])	
			>> lit(':')
			>> *space >> lit("var;")
		;
		
		reserved_var_list = name [push_back(at_c<0>(_val), _1)]	
			>>	*(lit(',') >> name  [push_back(at_c<0>(_val), _1)])	
			>> lit(':')
			>> *space >> lit("reserved_var;")
		;
		
		state = "loc" >> name [at_c<0>(_val) = _1]
			>> ":"
			>> "while"
			>> (expr [push_back(at_c<1>(_val), _1)] >> *("&" >> expr [push_back(at_c<1>(_val), _1)] ))
			>> "wait"
			>> -("{" >> -assign [at_c<2>(_val)=_1] >> "}")
			>> *trans [push_back(at_c<3>(_val), _1)]
		;
		automaton = lexeme["automaton"]
			>> name [at_c<0>(_val) = _1]
            >> -(lexeme["synclabs"] >> lexeme[":"] >> -(name [push_back(at_c<2>(_val), _1)] >> *(lexeme[","] >>  name [push_back(at_c<2>(_val), _1)])) >> lexeme[";"]) 
			>> +state [push_back(at_c<1>(_val), _1)]
			>> lexeme["end"]
		;
		trans = "when"
			>> (expr [push_back(at_c<0>(_val), _1)] >> *("&" >> expr [push_back(at_c<0>(_val), _1)] ))
			>> *("sync" >> name [at_c<1>(_val) = _1])
			>> "do"
			>> "{"
			//>> -assign [at_c<2>(_val)=_1]
			>> -(update [push_back(at_c<2>(_val), _1)] >> *("," >> update [push_back(at_c<2>(_val), _1)]))
			>> "}"
			>> "goto"
			>> name [at_c<3>(_val) = _1]
			>>";"
		;

		ss = lexeme["loc"] 
			>> lexeme["["] 
			>> name [at_c<0>(_val) = _1] 
			>> lexeme["]"] 
			>> lexeme["="] 
			>> name [at_c<1>(_val) = _1]
		;
		init = lexeme["init"] >> lexeme[":="] >> ss [push_back(at_c<0>(_val), _1)] >> *( "&" >> ss [push_back(at_c<0>(_val), _1)])
			>> +("&" >> expr [push_back(at_c<1>(_val), _1)]) >> ";"
			>> -(lexeme["bad"] >> lexeme[":="] >> ss [push_back(at_c<2>(_val), _1)] >> *( "&" >> ss [push_back(at_c<2>(_val), _1)]) >> ";")
		;

		model = *var_list [at_c<0>(_val)= _1]
		    >> *reserved_var_list [at_c<1>(_val)= _1]
			>> *params [at_c<2>(_val) = _1]
			>> *im_params [at_c<3>(_val) = _1]
			>> *automaton [push_back(at_c<4>(_val), _1)]
			>> *init [at_c<5>(_val) = _1]
		;
	}
};

MODEL parse(char const* filename)
{
    std::ifstream input(filename);

    if (!input)
    {
        std::cerr << "Error: Could not open input file: "
            << filename << std::endl;
     	exit(1);
    }

    MODEL mod; // Our tree
	myparse<Model_grammar, MODEL>(input, filename, mod);
	
	return mod;
}

template<template <class, class> class Grammar, class DataType> 
bool myparse(std::istream& input, const std::string filename, DataType &result)
{
    namespace qi = boost::spirit::qi;
    namespace ascii = boost::spirit::ascii;
    namespace classic = boost::spirit::classic;
   
    typedef std::istreambuf_iterator<char> base_iterator_type;
    base_iterator_type in_begin(input);
    
    // convert input iterator to forward iterator, usable by spirit parser
    typedef boost::spirit::multi_pass<base_iterator_type> forward_iterator_type;
    forward_iterator_type fwd_begin = boost::spirit::make_default_multi_pass(in_begin);
    forward_iterator_type fwd_end;
    
    // wrap forward iterator with position iterator, to record the position
    typedef classic::position_iterator2<forward_iterator_type> pos_iterator_type;
    pos_iterator_type position_begin(fwd_begin, fwd_end, filename);
    pos_iterator_type position_end;

    typedef forward_iterator_type used_iterator_type;
    used_iterator_type s = fwd_begin;
    used_iterator_type e = fwd_end;
    // typedef pos_iterator_type used_iterator_type;
    // used_iterator_type s = position_begin;
    // used_iterator_type e = position_end;

    qi::rule<used_iterator_type> skipper = ascii::space | 
	'#' >> *(ascii::char_ - qi::eol) >> qi::eol; // comment skipper, 

    Grammar<used_iterator_type, qi::rule<used_iterator_type> > g;
    bool r = false;
  
    try {
        r = phrase_parse(s, e, g, skipper, result);
    } catch(const qi::expectation_failure<used_iterator_type>& e)
    {
        std::stringstream msg;
        // const classic::file_position_base<std::string>& pos = e.first.get_position();
        // msg <<
        //     "parse error at file " << pos.file <<
        //     " line " << pos.line << " column " << pos.column << std::endl <<
        //     "'" << e.first.get_currentline() << "'" << std::endl <<
        //     std::setw(pos.column) << " " << "^- here";
	msg << "parse error";
        throw std::runtime_error(msg.str());
    }
    
    return r;
}
