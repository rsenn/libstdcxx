MOSYNCDIR ?= /opt/MoSync-4.0-Alpha
PROJECT = libstdcxx
VERSION = 3.4.6
PLATFORM = Android

PIPE_TOOL = "$(MOSYNCDIR)/bin/pipe-tool"
BUNDLE = "$(MOSYNCDIR)/bin/Bundle"
PACKAGE = "$(MOSYNCDIR)/bin/package"
ADB = "$(MOSYNCDIR)/bin/android/adb"
CC = "$(MOSYNCDIR)/bin/xgcc"
LN_S = ln -s

TARGET ?= pipe
CONFIG ?= release

ANDROID_VERSION = 16
ANDROID_KEYSTORE = mosync.keystore
ANDROID_STOREPASS = default
ANDROID_KEYPASS = default

DEFS = -DMAPIP 
CPPFLAGS =  -I"$(MOSYNCDIR)/include/maui-revamp"

ifeq ($(TARGET),newlib)
DEFS += -DNEWLIB
CPPFLAGS += -I"$(MOSYNCDIR)/include/newlib/stlport" -I"$(MOSYNCDIR)/include/newlib" 
LIBS = stlport.lib newlib.lib
else
CPPFLAGS += -I"$(MOSYNCDIR)/include"
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

LIBS += maui-revamp.lib mautil.lib 

APK = $(PROJECT).apk
BUILD_DIR := build/$(TARGET)_$(CONFIG)
OUTPUT_DIR := $(BUILD_DIR)/$(PLATFORM)
CURRENT_DIR := $(shell cygpath -m "$(SOURCE_DIR)" 2>/dev/null || echo .)

VPATH = $(OUTPUT_DIR):.
vpath $(OUTPUT_DIR) .

LIBSOURCES = $(wildcard config/io/*.cpp  libsupc++/*.cpp src/*.cpp) MAMain.cpp
SOURCES = $(LIBSOURCES) MAMain.cpp
#SOURCES += $(wildcard config/locale/gnu/*.cpp)
#SOURCES += $(wildcard config/locale/ieee_1003.1-2001/*.cpp)
#SOURCES += $(wildcard config/locale/generic/*.cpp) 
HEADERS = $(wildcard $(addprefix include/,algorithm backward/*.h backward/strstream bits/*.h bits/*.tcc bits/c++config bitset c/*.h c_compatibility/*.h c_std/*.h c_std/*.tcc cassert cctype cerrno cfloat ciso646 climits clocale cmath complex csetjmp csignal cstdarg cstddef cstdio cstdlib cstring ctime cwchar cwctype debug/*.h debug/*.tcc debug/bitset debug/deque debug/hash_map debug/hash_set debug/list debug/map debug/set debug/string debug/vector deque ext/*.h ext/algorithm ext/functional ext/hash_map ext/hash_set ext/iterator ext/memory ext/numeric ext/rb_tree ext/rope ext/slist fstream functional iomanip ios iosfwd iostream istream iterator limits list locale map mapip/bits/*.h memory noexcept.icc numeric ostream queue set sstream stack std/*.h stdc++.h stdexcept streambuf string utility valarray vector))
#SOURCES += $(wildcard libmath/*.c)
ASMSRCS = $(patsubst %.cpp,$(OUTPUT_DIR)/%.s,$(notdir $(SOURCES)))
OBJECTS = $(patsubst %.cpp,$(OUTPUT_DIR)/%.o,$(notdir $(SOURCES)))
PREPROCESSED = $(patsubst %.cpp,$(OUTPUT_DIR)/%.e,$(notdir $(SOURCES)))
CLEANFILES = $(ASMSRCS) $(OUTPUT_DIR)/*.o 
LIBRARY = stdc++.lib


ifeq ($(CONFIG),debug)
DBGSUFFIX = D
endif

define NL


endef

GENERATED = $(OUTPUT_DIR)/bits/basic_file.h $(OUTPUT_DIR)/bits/c++config.h $(OUTPUT_DIR)/bits/os_defines.h

.PHONY: all install install-libs install-headers preprocess depend clean install-apk start logclear logtail logcat logpull

all: $(OUTPUT_DIR) $(BUILD_DIR)/$(LIBRARY) $(OUTPUT_DIR)/program $(OUTPUT_DIR)/$(APK)

install: install-headers install-libs

install-libs:
#	install -d "$(MOSYNCDIR)/lib/$(TARGET)_$(CONFIG)"
	install -m 644 "$(BUILD_DIR)/stdc++.lib" "$(MOSYNCDIR)/lib/$(TARGET)/stdc++$(DBGSUFFIX).lib"
	install -m 644 "$(BUILD_DIR)/stdc++.lib" "$(MOSYNCDIR)/lib/$(TARGET)_$(CONFIG)/stdc++.lib"

install-headers:
	@echo "Install:" 1>&2
	@for H in $(subst include/,,$(HEADERS)); do \
		F="$(MOSYNCDIR)/include/c++/3.4.6/$$H"; \
		D=`dirname "$$F"`; \
		C="install -d \"$$D\"; install -m  644 \"include/$$H\" \"$$D\""; \
		echo "$$C" 1>&2; \
		eval "$$C"; \
	done

preprocess: $(PREPROCESSED)

-include .dep 

depend: $(SOURCES)
	$(CC) -MM $(DEFS) $(CPPFLAGS) $^ | sed "s|^\([^.]*\)\\.o|\$(OUTPUT_DIR)/\\1.s|" >.dep


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

$(BUILD_DIR)/$(LIBRARY): $(ASMSRCS) | $(GENERATED)
	$(PIPE_TOOL) -L $@ $^

%.s: %.cpp $(HEADERS)
	$(CC) $(DEFS) $(CPPFLAGS) $(CFLAGS) -S -o $@ $<

%.e: %.cpp $(HEADERS)
	$(CC) $(DEFS) $(CPPFLAGS) $(CFLAGS) -E -o $@ $<

clean:
	$(RM) $(CLEANFILES)  || true
	$(RM) -r $(OUTPUT_DIR)
	
$(OUTPUT_DIR)/program: $(ASMSRCS)
	$(PIPE_TOOL) $(PIPE_FLAGS) -s"$(MOSYNCDIR)/lib/${TARGET}_${CONFIG}" -B "$@" $^ $(LIBS) || { rm -f $(OUTPUT_DIR)/program; exit 1; }

$(OUTPUT_DIR)/$(APK): $(OUTPUT_DIR)/program
ifeq ($(CONFIG),debug)
	mkdir -p "$(BUILD_DIR)"
#	cp -rf "$(MOSYNCDIR)"/lib/android_armeabi_debug "$(BUILD_DIR)"
endif
	$(PACKAGE) $(PACKAGEFLAGS) \
		-t platform \
		-i "$(CURRENT_DIR)/libstdcxx.icon" \
		-p "$(CURRENT_DIR)/$(OUTPUT_DIR)/program" \
		-d "$(CURRENT_DIR)/$(OUTPUT_DIR)" \
		-m "$(PLATFORM)/$(PLATFORM)" \
		--vendor BuiltWithMoSyncSDK \
		-n "$(PROJECT)" \
		--version "$(VERSION)" \
		--output-type interpreted \
		--permissions "Compass,File Storage,File Storage/Read,File Storage/Write,Internet Access,Internet Access/HTTPS,Location,Location/Coarse,Location/Fine,Location/Coarse,Location/Fine,Vibration" \
		--android-package "com.mosync.app_$(PROJECT)" \
		--android-version-code $(ANDROID_VERSION) \
		--android-keystore "$(MOSYNCDIR)/etc/$(ANDROID_KEYSTORE)" \
		--android-storepass "$(ANDROID_STOREPASS)" \
		--android-alias "$(ANDROID_KEYSTORE)" \
		--android-keypass "$(ANDROID_KEYPASS)" \
		--android-install-location internalOnly

install-apk: all
	$(ADB) install -r $(OUTPUT_DIR)/$(APK)	

start: all logclear install-apk
	$(ADB) shell am start -n com.mosync.app_$(PROJECT)/com.mosync.app_$(PROJECT).MoSync
	$(ADB) logcat $(LOGCAT_FILTER) || { exit 0; }

LOGCAT_FILTER = -s -b main maWriteLog:D CordovaWebView:D WebViewChromium:D JsMessageQueue:D MoSync:D @@MoSync:D ActivityManager:D WindowState:D MoSyncLocation.onLocationChanged:D GCoreUlr:D
#LOGCAT_FILTER += PackageManager:D

logclear:
	$(ADB) logcat -c
logtail: logclear
	$(ADB) logcat $(LOGCAT_FILTER) || { exit 0; }
logcat:
	$(ADB) logcat -d $(LOGCAT_FILTER)
logpull:
	$(ADB) logcat -d $(LOGCAT_FILTER) >CrowdGuard.log
	$(ADB) logcat -c
	
$(foreach src,$(SOURCES), $(eval $(patsubst %.cpp,$(OUTPUT_DIR)/%.s,$(notdir $(src))): $(src)$(NL)	$$(CC) $$(DEFS) $$(CPPFLAGS) $$(CFLAGS) -S -o $$@ $$<	))


