#!/usr/bin/ruby

require File.expand_path(ENV['MOSYNCDIR']+'/rules/mosync_lib.rb')

mod = PipeLibWork.new
mod.instance_eval do
	def setup_native
		@LOCAL_DLLS = ["mosync", "mastd"]
		if(@GCC_IS_V4 && @GCC_V4_SUB >= 4)
			@EXTRA_CFLAGS = " -D_STDIO_H"
		end
		setup_base
	end
	
	def setup_pipe
		setup_base
	end
	
	def setup_base
		if(CONFIG == "")
			# broken compiler
			@SPECIFIC_CFLAGS = {"File.c" => " -Wno-unreachable-code"}
		else
			@SPECIFIC_CFLAGS = {}
		end
		#@SOURCES = ["libsupc++","src"]
		@SOURCES = ["src"]
		@EXTRA_INCLUDES = [".", "include/mapip", "include", "include/backward", "libsupc++"]
		@INSTALL_INCDIR = "libstdc++"
    @EXTRA_CFLAGS += " -fno-exceptions -fno-rtti -DLOCALES=1 "
		@NAME = "stdc++"
	end
end

mod.invoke
