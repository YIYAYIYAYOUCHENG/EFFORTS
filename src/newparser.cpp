#include <iostream>
#include <fstream>
#include <memory>

#include <parser.hpp>
#include "newparser.hpp"

using namespace std;

void create_task(mymodel &m, parser_context &pc)
{
    // cout << "Creating a task" << endl;
    task_mod t;
    auto x = pc.collect_tokens();
    if (x.size() < 1) throw("Expecting a task name");
    t.name = x[x.size() - 1].second;
    m.tasks.push_back(t);
    // cout << "Tasks are now " << m.tasks.size() << endl;
}

void read_tprop(mymodel &m, parser_context &pc)
{
    auto x = pc.collect_tokens();
    if (x.size() < 2) throw("Wrong property");
    // cout << "x.size() is " << x.size() << endl;
    // int i = m.tasks.size()-1;
    // cout << "Modifying task at position " << i << endl;
    if (x[0].first != LEX_IDENTIFIER) throw("Expecting a identifier");
    if (x[0].second == "C") {
	if (x[1].first != LEX_INT) throw ("Expecting an integer");
	m.tasks[m.tasks.size()-1].ctime = atoi(x[1].second.c_str());
    }
    if (x[0].second == "D") {
	if (x[1].first != LEX_INT) throw ("Expecting an integer");
	m.tasks[m.tasks.size()-1].dline = atoi(x[1].second.c_str());
    }
    if (x[0].second == "T") {
	if (x[1].first != LEX_INT) throw ("Expecting an integer");
	m.tasks[m.tasks.size()-1].period = atoi(x[1].second.c_str());
    }
    if (x[0].second == "type") {
	if (x[1].first != LEX_IDENTIFIER) throw ("Expecting an identifier");
	m.tasks[m.tasks.size()-1].type = x[1].second;
    }
}

void read_sprop(mymodel &m, parser_context &pc)
{
    auto x = pc.collect_tokens();
    if (x.size() < 2) throw("Wrong property");
    if (x[0].first != LEX_IDENTIFIER) throw("Expecting a identifier");
    if (x[0].second == "nproc") {
	if (x[1].first != LEX_INT) throw ("Expecting an integer");
	m.sys.nproc = atoi(x[1].second.c_str());
    }    
    if (x[0].second == "sched") {
	if (x[1].first != LEX_IDENTIFIER) throw ("Expecting an identifier");
	m.sys.sched = x[1].second;
    }
}


mymodel parsefile(const string &myfile)
{
    ifstream f(myfile.c_str());
    mymodel m;

    parser_context pc;
    pc.set_stream(f);

    using namespace std::placeholders;

    // The rules
    rule task_list, task, sys, tprop, sprop, ctime, dline, period, sched, nproc, tasktype;

    // a task list is a list of tasks
    task_list = *task;

    // the task properties
    ctime = keyword("C") >> rule('=') >> rule(tk_int) >> rule(';');
    dline = keyword("D") >> rule('=') >> rule(tk_int) >> rule(';');
    period = keyword("T") >> rule('=') >> rule(tk_int) >> rule(';');
    tasktype = keyword("type") >> rule('=') >> rule(tk_ident) >> rule(';');

    // the sys properties
    sched = keyword("sched") >> rule('=') >> rule(tk_ident) >> rule(';');
    nproc = keyword("nproc") >> rule('=') >> rule(tk_int) >> rule(';');

    tprop = (ctime | dline | period | tasktype);
    sprop = (sched | nproc );
    
    // These functions will read the properties and store them in m
    tprop[std::bind(read_tprop, std::ref(m), _1)];
    sprop[std::bind(read_sprop, std::ref(m), _1)];

    // task declaration
    // the function creates a task and stores its name
    task = keyword("task",false) >> (rule(tk_ident)[std::bind(&create_task, std::ref(m), _1)])
	                         >> rule('{') >> *tprop >> rule('}');
    // a sys declaration
    sys = keyword("sys",false) >> rule('{') >> *sprop >> rule('}');

    try {
	cout << "Parsing the system first : " << sys.parse(pc) << endl; 
	cout << "Parsing the tasks then : " << task_list.parse(pc) << endl;
    } catch (char const *msg) {
	cout << "ERROR" << endl;
	cout << msg << endl;
	cout << pc.get_formatted_err_msg() << endl;
    }
    
    return m;
}
