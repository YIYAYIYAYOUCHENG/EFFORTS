LDFLAGS = -lppl -lboost_program_options-mt -lgmp -pg -lprofiler -L/opt/local/lib/
CPPFLAGS = -pg -g -Wall -ftemplate-depth-1024 -I/opt/local/include

LINK_TARGET = HelloGProf

OBJS = HelloGProf.o 

REBUILDABLES = $(OBJS) $(LINK_TARGET)

all : $(LINK_TARGET)
	echo All done

$(LINK_TARGET) : $(OBJS)
	g++ $(CPPFLAGS) -o $@ $^ $(LDFLAGS)

#unique_index.o : unique_index.hpp
#main.o : model.hpp
#parser.o : parser.hpp
#model.o : model.hpp

clean : 
	rm -f $(REBUILDABLES)
	echo Clean done
