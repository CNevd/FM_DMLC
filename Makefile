# Makefile for wormhole project
ifneq ("$(wildcard ./config.mk)","")
	config = $(CURDIR)/config.mk
else
	config = $(CURDIR)/make/config.mk
endif

# number of threads
# NT=4

# the directory where deps are installed
DEPS_PATH=$(CURDIR)/deps

ROOTDIR = $(CURDIR)
REPOS = $(addprefix repo/, dmlc-core ps-lite rabit)

.PHONY: clean all test pull

all: lbfgs fm difacto
### repos and deps

# dmlc-core
repo/dmlc-core:
	git clone https://github.com/dmlc/dmlc-core $@
	ln -s repo/dmlc-core/tracker .

repo/dmlc-core/libdmlc.a: | repo/dmlc-core glog
	+	$(MAKE) -C repo/dmlc-core libdmlc.a config=$(config) DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)

core: | repo/dmlc-core glog					# always build
	+	$(MAKE) -C repo/dmlc-core libdmlc.a config=$(config) DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)


# ps-lite
repo/ps-lite:
	git clone https://github.com/dmlc/ps-lite $@
	cd $@; git checkout tags/v1; cd ..

repo/ps-lite/build/libps.a: | repo/ps-lite deps
	+	$(MAKE) -C repo/ps-lite ps config=$(config) DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)


ps-lite: | repo/ps-lite deps				# awlays build
	+	$(MAKE) -C repo/ps-lite ps config=$(config) DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)

# rabit
repo/rabit:
	git clone https://github.com/dmlc/rabit $@

repo/rabit/lib/librabit.a:  | repo/rabit
	+	$(MAKE) -C repo/rabit

rabit: repo/rabit/lib/librabit.a

# deps
include make/deps.mk

deps: gflags glog protobuf zmq lz4 cityhash

### toolkits

# lbfgs linear
learn/lbfgs-linear/lbfgs.dmlc: learn/lbfgs-linear/lbfgs.cc | repo/rabit/lib/librabit.a repo/dmlc-core/libdmlc.a
	+	$(MAKE) -C learn/lbfgs-linear lbfgs.dmlc DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)

bin/lbfgs.dmlc: learn/lbfgs-linear/lbfgs.dmlc
	cp $+ $@

lbfgs: bin/lbfgs.dmlc


# lbfgs fm
learn/lbfgs-fm/fm.dmlc: learn/lbfgs-fm/fm.cc | repo/rabit/lib/librabit.a repo/dmlc-core/libdmlc.a
	+	$(MAKE) -C learn/lbfgs-fm fm.dmlc DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)

bin/fm.dmlc: learn/lbfgs-fm/fm.dmlc
	cp $+ $@

fm: bin/fm.dmlc


# difacto
learn/difacto/build/difacto.dmlc: ps-lite core repo/ps-lite/build/libps.a repo/dmlc-core/libdmlc.a
	$(MAKE) -C learn/difacto config=$(config) DEPS_PATH=$(DEPS_PATH) CXX=$(CXX)

bin/difacto.dmlc: learn/difacto/build/difacto.dmlc
	cp $+ $@

difacto: bin/difacto.dmlc



pull:
	for prefix in $(REPOS); do \
		if [ -d $$prefix ]; then \
			cd $$prefix; git pull; cd $(ROOTDIR); \
		fi \
	done

clean:
	for prefix in $(REPOS); do \
		if [ -d $$prefix ]; then \
			$(MAKE) -C $$prefix clean; \
		fi \
	done
	rm -rf bin/*.dmlc
