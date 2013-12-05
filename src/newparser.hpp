#ifndef __NEWPARSER_HPP__
#define __NEWPARSER_HPP__

#include <string>
#include <vector>
struct task_mod {
    std::string name;
    int ctime;
    int dline;
    int period;
    std::string type;
};

struct sys_mod {
    int nproc;
    std::string sched;
};

struct mymodel {
    std::vector<task_mod> tasks;
    sys_mod sys;
};

mymodel parsefile(const std::string &myfile);

#endif
