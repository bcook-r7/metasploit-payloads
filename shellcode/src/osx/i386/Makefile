SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .s .o

ASFLAGS = -g
LDFLAGS = -macosx_version_min 10.4

AWK = awk
INSTALL = install

INSTALL_PROGRAM = $(INSTALL) -c
INSTALL_DATA = ${INSTALL} -c -m 644

prefix = /usr/local
exec_prefix = $(prefix)

bindir = $(exec_prefix)/bin
includedir = $(prefix)/include
oldincludedir = /usr/include

PROGRAMS = \
	shell_bind_tcp \
	shell_find_port \
	shell_reverse_tcp

objects = \
	shell_bind_tcp.o \
	shell_find_port.o \
	shell_reverse_tcp.o

headers = \
	shell_bind_tcp.h \
	shell_find_port.h \
	shell_reverse_tcp.h

payloads = \
	shell_bind_tcp.rb \
	shell_find_port.rb \
	shell_reverse_tcp.rb

.PHONY: all
all: $(PROGRAMS) $(headers) $(payloads)


shell_bind_tcp.o: shell_bind_tcp.s
	$(AS) -arch i386 $(ASFLAGS) -o $@ $<

shell_find_port.o: shell_find_port.s
	$(AS) -arch i386 $(ASFLAGS) -o $@ $<

shell_reverse_tcp.o: shell_reverse_tcp.s
	$(AS) -arch i386 $(ASFLAGS) -o $@ $<

shell_bind_tcp: shell_bind_tcp.o
	$(LD) -arch i386 $(LDFLAGS) -o $@ $<

shell_find_port: shell_find_port.o
	$(LD) -arch i386 $(LDFLAGS) -o $@ $<

shell_reverse_tcp: shell_reverse_tcp.o
	$(LD) -arch i386 $(LDFLAGS) -o $@ $<

shell_bind_tcp.h: shell_bind_tcp.o
	cat $@.in > $@
	otool -t $< | $(AWK) -f ../../tools/otool2h.awk -v name=shell_bind_tcp >> $@

shell_find_port.h: shell_find_port.o
	cat $@.in > $@
	otool -t $< | $(AWK) -f ../../tools/otool2h.awk -v name=shell_find_port >> $@

shell_reverse_tcp.h: shell_reverse_tcp.o
	cat $@.in > $@
	otool -t $< | $(AWK) -f ../../tools/otool2h.awk -v name=shell_reverse_tcp >> $@

shell_bind_tcp.rb: shell_bind_tcp.o
	cat $@.in > $@
	otool -t $< | $(AWK) -f ../../tools/otool2rb.awk >> $@

shell_find_port.rb: shell_find_port.o
	cat $@.in > $@
	otool -t $< | $(AWK) -f ../../tools/otool2rb.awk >> $@

shell_reverse_tcp.rb: shell_reverse_tcp.o
	cat $@.in > $@
	otool -t $< | $(AWK) -f ../../tools/otool2rb.awk >> $@

.PHONY: install
install:
	mkdir -p $(DESTDIR)$(includedir)
	$(INSTALL_DATA) $(headers) $(DESTDIR)$(includedir)

.PHONY: install-payloads
install-payloads: DESTDIR ?= /opt/metasploit
install-payloads:
	mkdir -p $(DESTDIR)/modules/payloads/singles/osx/x86
	$(INSTALL_DATA) $(payloads) $(DESTDIR)/modules/payloads/singles/osx/x86

.PHONY: uninstall
uninstall:
	-cd $(DESTDIR)$(includedir) && rm -f $(headers)

.PHONY: uninstall-payloads
uninstall-payloads: DESTDIR ?= /opt/metasploit
uninstall-payloads:
	-cd $(DESTDIR)/modules/payloads/singles/osx/x86 && rm -f $(payloads)

.PHONY: clean
clean:
	-rm -f $(PROGRAMS) $(objects) $(headers) $(payloads)
