

CXX = g++

DEBUG = 0


#INC_DIRS = -I"." -I"/opt/boost/include" -I"src" -I"utils"
INC_DIRS = -I"$(BOOST_ROOT)/include"
LIB_DIRS = -L"$(BOOST_ROOT)/lib"


# By default lets just build DEBUG
CXXFLAGS = -O0 -ggdb3 -fPIC -std=c++17


VERSION = v1.0.0
#VERSION = $(shell git describe --abbrev=8 --dirty --always --tags)


#ifeq ($(DEBUG),1)
#   CXXFLAGS = -O0 -ggdb3 -fPIC -std=c++17
#else
#   CXXFLAGS = -O3 -pthread -fPIC -fomit-frame-pointer -march=native -Wno-write-strings -ffloat-store -ffast-math -fno-math-errno -std=c++17 -DVERSION=\"$(VERSION)\"
#endif

# For speed
#CXXFLAGS = -O3 -pthread -ffast-math -ffloat-store -fPIC
#CXXFLAGS = -O3 -pthread -fPIC
# Not currently supported -flto -fmudflapir -fmudflapth
# For c++14 testing
# CXXFLAGS = -O0 -pthread -g -fPIC -std=c++14
# For debugging with the most verbose errors and warnings
#CXXFLAGS = -O0 -pthread -g -fPIC -Wall

LDFLAGS = -pthread -lrt -ldl -lz -lboost_system -lboost_thread -lboost_filesystem -lboost_date_time -luuid -lssl -lcrypto


# Use this for multiple directories
csrc =	$(wildcard src/*.cpp)
obj = 	$(csrc:.cpp=.o)
dep = 	$(wildcard src/*.h)
deps =	$(dep:.h=.d)

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $(INC_DIRS) $< -o $@

../bin/kraken: $(obj)
	$(CXX) $(LIB_DIRS) -o $@ $^ $(LDFLAGS)
#	$(CXX) $(LIBPATH) -Wl,-rpath,../lib -o $@ $^ $(LDFLAGS)

-include $(deps)
%.d: %.cpp
		@$(CXX) $(CXXFLAGS) $(INC_DIRS) $< -MM -MT $(@:.d=.o) >$@


.PHONY: clean
clean:
		rm -f ../bin/kraken $(obj)

.PHONY: cleandep
cleandep:
		rm -f $(deps)

.PHONY: cleanall
cleanall:
		rm -f ../bin/kraken $(obj)
		rm -f $(deps)





