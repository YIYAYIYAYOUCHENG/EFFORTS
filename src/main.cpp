#include "parser.hpp"
#include "model.hpp"
#include <boost/ref.hpp>
#include <boost/program_options.hpp>
#include "newparser.hpp"

namespace po = boost::program_options;

int main(int argc, char **argv)
{
  
  po::options_description options(argv[0]);
  options.add_options()
    ("help,h", "Use -h or --help to list all arguments")
    ("imcr,i", "Parameter synthesis Inverse Method with Complete Results")
    ("psy,p", "Parameter synthesis with breath first iteration")
    ("reach,r", "Reachability analysis by breath first iteration")
    ("file,f", po::value<string>(), "The input file")
    ("with-log", "In the end of operation, a log file will be generated")
    ("fast-reach", "Reachability test; when the target location is reached, the application stops")
    ("fpfp-sim", "Option to trigger FPFP simulation relation")
    ("op", "Set this option to remove all redundent states") 
      ("newparser", "this uses the new parser")
    ;
  
  po::variables_map vm;
  po::store( po::parse_command_line(argc, argv, options), vm);
  po::notify(vm);

  if( vm.count("help")) {
    cout << options << endl;
  }

  if(!vm.count("file")) {
    cout << "Input file is missed!" << endl;
    exit(1);
  }

  if(! (vm.count("imcr") || vm.count("psy") || vm.count("reach") || vm.count("fast-reach")) ) {
    cout << "An option to run xtool should be specified!" << endl;
    exit(1);
  }
  
  string fname (vm["file"].as<string>());
  //string fname (argv[1]);
  
  if (vm.count("newparser")) {
      cout << "Starting the new parser" << endl;
      parsefile(fname);
      exit(-1);
  }
  Model mod (parse(fname.c_str()));
  if (vm.count("fpfp-sim"))
    mod.set_fpfp_sim();
  if (vm.count("op"))
    mod.set_op();
  //mod.print();

  if( vm.count("psy")) {
    cout << "------------------------------------------\n";
    cout << "Parameter synthesis :\n";
    cout << "------------------------------------------\n";
    mod.bf_psy();
  }

  if( vm.count("reach")) {
    cout << "------------------------------------------\n";
    cout << "Reachability analysis :\n";
    cout << "------------------------------------------\n";
    mod.type = REACH;
    mod.bf_psy();
    //cout << "The target location is not reached.\n";
    if( vm.count("with-log")) {
      cout << "Generating the log file ...\n"; 
      string f = fname + string(".log");
      mod.print_log(f);
    }
  }

  if( vm.count("fast-reach")) {
    cout << "------------------------------------------\n";
    cout << "Fast reachability analysis :\n";
    cout << "------------------------------------------\n";
    mod.type = FAST_REACH;
    try {
      mod.bf_psy();
      cout << "The target location is not reached.\n";
    } 
    catch (int e) {
      if (e == 0) { cout << "The target is reached!\n"; }
    }

    if( vm.count("with-log")) {
      cout << "Generating the log file ...\n"; 
      string f = fname + string(".log");
      mod.print_log(f);
    }
    return 0;

  }
	//if( vm.count("imcr")) {
	//	cout << "------------------------------------------\n";
	//	cout << "Parameter synthesis with IMCR:\n";
	//	cout << "------------------------------------------\n";
	//	mod.imcr();
	//	cout << "\n--------------------------------------------------\n";
	//	cout << "The number of unfeasible paths to be synthesized : ";
	//	cout << mod.unfeasible_path_set.size() << endl;
	//	cout << "The number of feasible paths to be synthesized : ";
	//	cout << mod.feasible_path_set.size() << endl;
	//	cout << "----------------------------------------------------\n";
	//}

	cout << "Done! \n";

}
