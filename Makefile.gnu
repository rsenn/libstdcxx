MOSYNCDIR ?= /opt/MoSync-4.0-Alpha
PROJECT = libstdc++v3
VERSION = 3.4.6

PIPE_TOOL = $(MOSYNCDIR)/bin/pipe-tool
BUNDLE = $(MOSYNCDIR)/bin/Bundle
PACKAGE = $(MOSYNCDIR)/bin/package
CC = $(MOSYNCDIR)/bin/xgcc
LN_S = ln -s

TARGET ?= pipe
CONFIG ?= release

ANDROID_KEYSTORE = mosync.keystore
ANDROID_STOREPASS = default
ANDROID_KEYPASS = default

DEFS = -DMAPIP 

ifeq ($(TARGET),newlib)
DEFS += -DNEWLIB
CPPFLAGS = -I"$(MOSYNCDIR)/include/newlib/stlport" -I"$(MOSYNCDIR)/include/newlib" 
LIBS = stlport.lib newlib.lib
else
CPPFLAGS = -I"$(MOSYNCDIR)/include"
LIBS = mastd.lib
endif

CPPFLAGS += -Iinclude -Iinclude/backward -Iinclude/mapip -Ilibsupc++

PIPE_FLAGS = #-appcode=YSYW -stabs=stabs.tab -heapsize=3145728 -stacksize=524288 -datasize=4194304 -sld=sld.tab

ifeq ($(CONFIG),debug)
CFLAGS = -g -ggdb -O -Wall
#DEFS += -DDEBUG
DEFS += -DDEBUG
else
CFLAGS = -O2 -Wall 
endif

#LIBS += mautil.lib mafs.lib mtxml.lib

OUTPUT_DIR = build/$(CONFIG)

VPATH = $(OUTPUT_DIR):.
vpath $(OUTPUT_DIR) .

SOURCES = $(wildcard config/io/*.cc  libsupc++/*.cc src/*.cc)
#SOURCES += $(wildcard config/locale/gnu/*.cc)
#SOURCES += $(wildcard config/locale/ieee_1003.1-2001/*.cc)
#SOURCES += $(wildcard config/locale/generic/*.cc) 
HEADERS = $(wildcard acconfig.h/*.h config/cpu/alpha/*.h config/cpu/sparc/*.h config/cpu/generic/*.h config/cpu/s390/*.h config/cpu/hppa/*.h config/cpu/cris/*.h config/cpu/i386/*.h config/cpu/m68k/*.h config/cpu/i486/*.h config/cpu/mips/*.h config/cpu/ia64/*.h config/cpu/powerpc/*.h config/locale/generic/*.h config/locale/ieee_1003.1-2001/*.h config/locale/gnu/*.h config/allocator/*.h config/io/*.h config/os/newlib/*.h config/os/generic/*.h config/os/vxworks/*.h config/os/windiss/*.h config/os/aix/*.h config/os/gnu-linux/*.h config/os/solaris/solaris2.5/*.h config/os/solaris/solaris2.7/*.h config/os/solaris/solaris2.6/*.h config/os/tpf/*.h config/os/bsd/freebsd/*.h config/os/bsd/netbsd/*.h config/os/hpux/*.h config/os/mingw32/*.h config/os/qnx/qnx6.1/*.h config/os/irix/*.h config/os/irix/irix5.2/*.h config/os/irix/irix6.5/*.h config/os/irix/*.h config/os/djgpp/*.h include/ext/*.h include/std/*.h include/backward/*.h include/c_compatibility/*.h include/*.h include/debug/*.h include/c/*.h include/bits/*.h include/c_std/*.h libmath/*.h libsupc++/*.h)
#SOURCES += $(wildcard libmath/*.c)
ASMSRCS = $(patsubst %.cc,$(OUTPUT_DIR)/%.s,$(notdir $(SOURCES)))
OBJECTS = $(patsubst %.cc,$(OUTPUT_DIR)/%.o,$(notdir $(SOURCES)))
PREPROCESSED = $(patsubst %.cc,$(OUTPUT_DIR)/%.e,$(notdir $(SOURCES)))
CLEANFILES = $(ASMSRCS) $(OUTPUT_DIR)/*.o 
LIBRARY = stdc++.lib

define NL


endef

GENERATED = $(OUTPUT_DIR)/bits/basic_file.h $(OUTPUT_DIR)/bits/c++config.h $(OUTPUT_DIR)/bits/os_defines.h

all: $(OUTPUT_DIR) $(OUTPUT_DIR)/$(LIBRARY)

preprocess: $(PREPROCESSED)

-include .dep 

depend: $(SOURCES)
	"$(CC)" -MM $(DEFS) $(CPPFLAGS) $^ | sed "s|^\([^.]*\)\\.o|\$(OUTPUT_DIR)/\\1.s|" >.dep


$(OUTPUT_DIR)/bits/os_defines.h: config/os/newlib/os_defines.h
	mkdir -p $(OUTPUT_DIR)/bits
	$(RM) $@
	$(LN_S) ../../../$< $@

$(OUTPUT_DIR)/bits/basic_file.h: config/io/basic_file_stdio.h
	mkdir -p $(OUTPUT_DIR)/bits
	$(RM) $@
	$(LN_S) ../../../$< $@

$(OUTPUT_DIR)/bits/c++config.h: include/bits/c++config
	mkdir -p $(OUTPUT_DIR)/bits
	$(RM) $@
	$(LN_S) ../../../$< $@


$(OUTPUT_DIR):
	mkdir -p $@

$(OUTPUT_DIR)/$(LIBRARY): $(ASMSRCS) | $(GENERATED)
	"$(PIPE_TOOL)" -L $@ $^

%.s: %.cpp $(HEADERS)
	"$(CC)" $(DEFS) $(CPPFLAGS) $(CFLAGS) -S -o $@ $<

%.e: %.cpp $(HEADERS)
	"$(CC)" $(DEFS) $(CPPFLAGS) $(CFLAGS) -E -o $@ $<

clean:
	$(RM) $(CLEANFILES)  || true
	$(RM) -r $(OUTPUT_DIR)

install: all

$(foreach src,$(SOURCES), $(eval $(patsubst %.cc,$(OUTPUT_DIR)/%.s,$(notdir $(src))): $(src)$(NL)	"$$(CC)" $$(DEFS) $$(CPPFLAGS) $$(CFLAGS) -S -o $$@ $$<	))

