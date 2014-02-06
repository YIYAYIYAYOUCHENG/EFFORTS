LDFLAGS = -lppl -lgmp -lprofiler /Users/syc/Workspace/Softwares/boost_1_55_0/stage/lib/libboost_system.a /Users/syc/Workspace/Softwares/boost_1_55_0/stage/lib/libboost_thread.a /Users/syc/Workspace/Softwares/boost_1_55_0/stage/lib/libboost_program_options.a
CPPFLAGS = -g -Wall -ftemplate-depth-1024 -std=gnu++0x -I/Users/syc/Workspace/Softwares/boost_1_55_0 -stdlib=libc++

LINK_TARGET = ../binary/efforts

OBJS = unique_index.o parser.o model.o main.o #parser_test.o 
#OBJS = unique_index.o parser.o model.o parser_test.o 

REBUILDABLES = $(OBJS) $(LINK_TARGET)

all : $(LINK_TARGET)
	echo All done

$(LINK_TARGET) : $(OBJS)
	g++ $(CPPFLAGS) -o $@ $^ $(LDFLAGS)

unique_index.o : unique_index.hpp
main.o : model.hpp
parser.o : parser.hpp
model.o : model.hpp

clean : 
	rm -f $(REBUILDABLES)
	echo Clean done
