SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .c .o

CFLAGS = -g -Wall
CPPFLAGS =
LDFLAGS =

INSTALL = install

INSTALL_PROGRAM = $(INSTALL) -c
INSTALL_DATA = ${INSTALL} -c -m 644

prefix = /usr/local
exec_prefix = $(prefix)

bindir = $(exec_prefix)/bin
includedir = $(prefix)/include
oldincludedir = /usr/include

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

PROGRAMS = \
	shell_find_client \
	shell_find_server

.PHONY: all
all: $(subdir) $(PROGRAMS)


.PHONY: $(subdir)
$(subdir):
	cd ../$(subdir)/$(arch) && $(MAKE)

shell_find_client: $(subdir) shell_find_client.c
	$(CC) -I. -I../$(subdir)/$(arch) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ shell_find_client.c

shell_find_server: $(subdir) shell_find_server.c
	$(CC) -I. $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ shell_find_server.c

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(bindir)
	$(INSTALL_PROGRAM) $(PROGRAMS) $(DESTDIR)$(bindir)

.PHONY: uninstall
uninstall:
	-cd $(DESTDIR)$(bindir) && rm -f $(PROGRAMS)

.PHONY: clean
clean:
	-rm -f $(PROGRAMS)
	-rm -fr *.dSYM
