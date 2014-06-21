## Makefile for the src subdirectory of the GNU C++ Standard library.
##
## Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003
## Free Software Foundation, Inc.
##
## This file is part of the libstdc++ version 3 distribution.
## Process this file with automake to produce Makefile.in.

## This file is part of the GNU ISO C++ Library.  This library is free
## software; you can redistribute it and/or modify it under the
## terms of the GNU General Public License as published by the
## Free Software Foundation; either version 2, or (at your option)
## any later version.

## This library is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## You should have received a copy of the GNU General Public License along
## with this library; see the file COPYING.  If not, write to the Free
## Software Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307,
## USA.

include $(top_srcdir)/fragment.am

# Cross compiler support.
toolexeclib_LTLIBRARIES = libstdc++.la

# Symbol versioning for shared libraries.
if GLIBCXX_BUILD_VERSIONED_SHLIB
version_arg = -Wl,--version-script=libstdc++-symbol.ver
version_dep = libstdc++-symbol.ver
libstdc++-symbol.ver:  ${glibcxx_srcdir}/$(SYMVER_MAP)
	cp ${glibcxx_srcdir}/$(SYMVER_MAP) ./libstdc++-symbol.ver
	if test "x$(port_specific_symbol_files)" != x; then \
	  sed -n '1,/DO NOT DELETE/p' $@ > tmp.top; \
	  sed -n '/DO NOT DELETE/,$$p' $@ > tmp.bottom; \
	  cat tmp.top $(port_specific_symbol_files) tmp.bottom > $@; \
	  rm tmp.top tmp.bottom; \
	fi
else
version_arg =
version_dep =
endif


# Source files linked in via configuration/make substitution for a
# particular host.
host_sources = \
	atomicity.cc \
	codecvt.cc_members.cc \
	collate_members.cc \
	ctype.cc_members.cc \
	messages_members.cc \
	monetary_members.cc \
	numeric_members.cc \
	time_members.cc 

codecvt.cc_members.cc: ${glibcxx_srcdir}/$(CCODECVT_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CCODECVT_CC) . || true

collate_members.cc: ${glibcxx_srcdir}/$(CCOLLATE_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CCOLLATE_CC) . || true

ctype.cc_members.cc: ${glibcxx_srcdir}/$(CCTYPE_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CCTYPE_CC) . || true

messages_members.cc: ${glibcxx_srcdir}/$(CMESSAGES_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CMESSAGES_CC) . || true

monetary_members.cc: ${glibcxx_srcdir}/$(CMONEY_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CMONEY_CC) . || true

numeric_members.cc: ${glibcxx_srcdir}/$(CNUMERIC_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CNUMERIC_CC) . || true

time_members.cc: ${glibcxx_srcdir}/$(CTIME_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CTIME_CC) . || true

atomicity_file = ${glibcxx_srcdir}/$(ATOMICITY_SRCDIR)/atomicity.h
atomicity.cc: ${atomicity_file}
	$(LN_S) ${atomicity_file} ./atomicity.cc || true

# Source files linked in via configuration/make substitution for a
# particular host, but with ad hoc naming rules.
host_sources_extra = \
	basic_file.cc \
	c++locale.cc.cpp

c++locale.cc.cpp: ${glibcxx_srcdir}/$(CLOCALE_CC)
	$(LN_S) ${glibcxx_srcdir}/$(CLOCALE_CC) ./$@ || true

basic_file.cc: ${glibcxx_srcdir}/$(BASIC_FILE_CC)
	$(LN_S) ${glibcxx_srcdir}/$(BASIC_FILE_CC) ./$@ || true

# Sources present in the src directory.
sources = \
	allocator.cc.cpp \
	codecvt.cc.cpp \
	complex_io.cc.cpp \
	ctype.cc.cpp \
	debug.cc.cpp \
	debug.cc_list.cc.cc.cpp \
	functexcept.cc.cpp \
	globals_locale.cc.cc.cpp \
	globals_io.cc.cpp \
	ios.cc.cpp \
	ios.cc_failure.cpp \
	ios.cc_init.cc.cpp \
	ios.cc_locale.cc.cc.cpp \
	limits.cc.cpp \
	list.cc.cpp \
	locale.cc.cpp \
	locale.cc_init.cpp \
	locale.cc_facets.cc.cpp \
	locale.ccname.cpp \
	stdexcept.cc.cpp \
	strstream.cc.cpp \
	tree.cc.cpp \
	allocator.cc-inst.cpp \
	concept-inst.cc.cpp \
	fstream-inst.cc.cpp \
	ext-inst.cc.cpp \
	io-inst.cc.cpp \
	istream-inst.cc.cpp \
	locale.cc-inst.cc.cpp \
	locale.cc-misc-inst.cc.cpp \
	misc-inst.cc.cpp \
	ostream-inst.cc.cpp \
	sstream-inst.cc.cpp \
	streambuf-inst.cc.cpp \
	string-inst.cc.cpp \
	valarray-inst.cc.cpp \
	wlocale.cc-inst.cc.cpp \
	wstring-inst.cc.cc.cpp \
	${host_sources} \
	${host_sources_extra}

VPATH = $(top_srcdir)/src:$(top_srcdir)

libstdc___la_SOURCES = $(sources)

libstdc___la_LIBADD = \
	$(top_builddir)/libmath/libmath.la \
	$(top_builddir)/libsupc++/libsupc++convenience.la

libstdc___la_DEPENDENCIES = ${version_dep} $(libstdc___la_LIBADD)

libstdc___la_LDFLAGS = \
	-version-info $(libtool_VERSION) ${version_arg} -lm 


# Use special rules for the deprecated source files so that they find
# deprecated include files.
GLIBCXX_INCLUDE_DIR=$(glibcxx_builddir)/include
strstream.cc.lo: strstream.cc.cpp
	$(LTCXXCOMPILE) -I$(GLIBCXX_INCLUDE_DIR)/backward -Wno-deprecated -S $<
strstream.cc.o: strstream.cc.cpp
	$(CXXCOMPILE) -I$(GLIBCXX_INCLUDE_DIR)/backward -Wno-deprecated -S $<

# Use special rules for the concept-checking instantiations so that all
# the generated template functions are also instantiated.  Force the checks
# to be on so that the instantiations are actually seen.
concept-inst.cc.lo: concept-inst.cc.cpp
	$(LTCXXCOMPILE) -D_GLIBCXX_CONCEPT_CHECKS -fimplicit-templates -S $<
concept-inst.cc.o: concept-inst.cc.cpp
	$(CXXCOMPILE) -D_GLIBCXX_CONCEPT_CHECKS -fimplicit-templates -S $<

# AM_CXXFLAGS needs to be in each subdirectory so that it can be
# modified in a per-library or per-sub-library way.  Need to manually
# set this option because CONFIG_CXXFLAGS has to be after
# OPTIMIZE_CXXFLAGS on the compile line so that -O2 can be overridden
# as the occasion calls for it.
AM_CXXFLAGS = \
	-fno-implicit-templates \
	$(WARN_CXXFLAGS) \
	$(OPTIMIZE_CXXFLAGS) \
	$(CONFIG_CXXFLAGS)


# libstdc++ libtool notes

# 1) Need to explicitly set LTCXXCOMPILE so that AM_CXXFLAGS is
# last. (That way, things like -O2 passed down from the toplevel can
# be overridden by --enable-debug.cc.)

# 2) In general, libtool expects an argument such as `--tag=CXX' when
# using the C++ compiler, because that will enable the settings
# detected when C++ support was being configured.  However, when no
# such flag is given in the command line, libtool attempts to figure
# it out by matching the compiler name in each configuration section
# against a prefix of the command line.  The problem is that, if the
# compiler name and its initial flags stored in the libtool
# configuration file don't match those in the command line, libtool
# can't decide which configuration to use, and it gives up.  The
# correct solution is to add `--tag CXX' to LTCXXCOMPILE and maybe
# CXXLINK, just after $(LIBTOOL), so that libtool doesn't have to
# attempt to infer which configuration to use
LTCXXCOMPILE = $(LIBTOOL) --mode=compile $(CXX) $(INCLUDES) \
	       $(AM_CPPFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(AM_CXXFLAGS)

# 3) We'd have a problem when building the shared libstdc++ object if
# the rules automake generates would be used.  We cannot allow g++ to
# be used since this would add -lstdc++ to the link line which of
# course is problematic at this point.  So, we get the top-level
# directory to configure libstdc++-v3 to use gcc as the C++
# compilation driver.
CXXLINK = $(LIBTOOL) --mode=link $(CXX) \
	  $(OPT_LDFLAGS) $(SECTION_LDFLAGS) $(AM_CXXFLAGS) $(LDFLAGS) -o $@


# Added bits to build debug.cc library.
if GLIBCXX_BUILD_DEBUG
all-local: build_debug.cc
install-data-local: install_debug.cc
else
all-local:
install-data-local:
endif

debug.ccdir = debug.cc

# Build parallel set of debug.cc objects here.
stamp-debug.cc:
	if test ! -d ${debug.ccdir}; then \
	  mkdir -p ${debug.ccdir}; \
	  (cd ${debug.ccdir}; \
	  sed -e 's/top_builddir = \.\./top_builddir = ..\/../' \
	      -e 's/srcdir = \.\./srcdir = ..\/../' \
	      -e 's/glibcxx_basedir = \.\./glibcxx_basedir = ..\/../' \
	      -e 's/all-local: build_debug.cc/all-local:/' \
	      -e 's/install-data-local: install_debug.cc/install-data-local:/' \
	  < ../Makefile > Makefile) ; \
	fi; \
	echo `date` > stamp-debug.cc;

build_debug.cc: stamp-debug.cc
	(cd ${debug.ccdir} && $(MAKE) CXXFLAGS='$(DEBUG_FLAGS)' all)

# Install debug.cc library here.
install_debug.cc:
	(cd ${debug.ccdir} && $(MAKE) \
	toolexeclibdir=$(glibcxx_toolexeclibdir)/debug.cc install)
