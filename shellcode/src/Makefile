SHELL = /bin/sh

.SUFFIXES:

arch := $(shell sh -c 'uname -p 2>/dev/null || echo')
system := $(shell sh -c 'uname -s 2>/dev/null || echo')

ifeq ($(system), AIX)
	subdir = aix
endif

ifneq ($(findstring BSD, $(system)),)
	subdir = bsd
endif

ifeq ($(system), Darwin)
	CFLAGS += -arch $(arch)
	subdir = osx
endif

ifeq ($(system), Linux)
	subdir = linux
endif

ifeq ($(system), SunOS)
	subdir = solaris
endif

.PHONY: all
all: $(subdir)


.PHONY: $(subdir)
$(subdir):
	cd $(subdir)/$(arch) && $(MAKE)

.PHONY: install
install:
	cd $(subdir)/$(arch) && $(MAKE) install
	cd test && $(MAKE) install

.PHONY: install-payloads
install-payloads:
	cd $(subdir)/$(arch) && $(MAKE) install-payloads

.PHONY: uninstall
uninstall:
	-cd $(subdir)/$(arch) && $(MAKE) uninstall
	-cd test && $(MAKE) uninstall

.PHONY: uninstall-payloads
uninstall-payloads:
	-cd $(subdir)/$(arch) && $(MAKE) uninstall-payloads

.PHONY: clean
clean:
	-cd $(subdir)/$(arch) && $(MAKE) clean
	-cd test && $(MAKE) clean

.PHONY: distclean
distclean: clean


.PHONY: dist
dist:
