LDFLAGS = -lppl -lboost_program_options -lgmp
CPPFLAGS = -g -Wall -I../../tipa/src/	


LINK_TARGET = ../binary/efforts

OBJS = unique_index.o parser.o model.o main.o newparser.o 
#OBJS = unique_index.o parser.o model.o parser_test.o 

REBUILDABLES = $(OBJS) $(LINK_TARGET)

all : $(LINK_TARGET)
	echo All done

$(LINK_TARGET) : $(OBJS)
#	g++ $(CPPFLAGS) -o $@ $^ $(LDFLAGS)
	libtool --mode=link g++ $(CPPFLAGS) -o $@ $^ $(LDFLAGS) ../../tipa/src/libtinyparser.la

unique_index.o : unique_index.hpp
main.o : model.hpp
parser.o : parser.hpp
model.o : model.hpp
newparser.o : newparser.cpp newparser.hpp
	g++ -c -std=c++0x $(CPPFLAGS) newparser.cpp 

clean : 
	rm -f $(REBUILDABLES)
	echo Clean done
