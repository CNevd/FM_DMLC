
include ../../dmlc-core/make/config.mk
include ../../dmlc-core/make/dmlc.mk

BIN = linear.dmlc

# common build script for programs

export LDFLAGS= -L../../lib -pthread -lm -lrt $(DMLC_LDFLAGS)
export CFLAGS = -Wall  -msse2  -Wno-unknown-pragmas -fPIC -I../../rabit/include  -I../../dmlc-core/include -std=c++11 -fopenmp

ifdef DEPS_PATH
CFLAGS+= -I$(DEPS_PATH)/include
LDFLAGS+= -L$(DEPS_PATH)/lib
endif

linear.dmlc : linear.cc ../../dmlc-core/libdmlc.a ../../rabit/lib/librabit.a

all: $(BIN) 

$(BIN) : 
	$(CXX) $(CFLAGS) -o $@ $(filter %.cpp %.o %.c %.cc %.a,  $^) $(LDFLAGS)

clean:
	$(RM) $(OBJ) $(BIN)  *~ ../src/*~

