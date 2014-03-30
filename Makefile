# Compile all files with extension IN_EXT in directory IN_DIR into or into a single output file.
# IN_EXT can be either of: `.cpp`, `.c` or `.f`. The compiler is chosen accordingly.

-include Makefile_params

# Basename of the file to generate assembly code for:
ASSEMBLE_BASENAME 		?= a.c
AUX_DIR 				?= _aux/
AUX_EXT 				?= .o
FF						?= gfortran
DEBUG_DEFINE 			?=
DEBUG_FLAGS 			?=
# For -DDEBUG and -DPROFILE, used dedicated DEFINES
DEFINES 				?= #-DPOSIX
IN_EXT 					?= .cpp
IN_DIR 					?= ./
INCLUDE_DIRS 			?= #-L/usr/include/GL
LIBS 					?= #-lglut -lGLU -lGL
MYCC					?= gcc
MYCFLAGS				?= -std=c11   -Wall -pedantic-errors -march=native $(CFLAGS_EXTRA)
MYCXX					?= g++
MYCXXFLAGS				?= -std=c++11 -Wall -pedantic-errors -march=native $(CXXFLAGS_EXTRA)
PREDEF 					?= #-DDEBUG -DPROFILE -DWINDOWS
# Passed as command line args to bin on run.
RUN_ARGS 				?= #0 1
OPTIMIZE_FLAGS			?= -O3
OUT_DIR 				?= ./
OUT_BASENAME_NOEXT		?= main
OUT_EXT 				?=
PROFILE_DEFINE 			?=
PROFILE_FLAGS 			?=

INS 		:= $(wildcard $(IN_DIR)*$(IN_EXT))
INS_NODIR 	:= $(notdir $(INS))
AUXS_NODIR	:= $(INS_NODIR:$(IN_EXT)=$(AUX_EXT))
AUXS		:= $(addprefix $(AUX_DIR),$(AUXS_NODIR))

OUT_BASENAME:= $(OUT_BASENAME_NOEXT)$(OUT_EXT)
OUT			:= $(OUT_DIR)$(OUT_BASENAME)

.PHONY: all mkdir clean assembler debug set_debug_flags profile set_profile_flags help ubuntu_install_deps

all: mkdir $(OUT)

$(OUT): $(AUXS)
	$(MYCXX) $(PROFILE_FLAGS) $^ -o "$@" $(LIBS)

$(AUX_DIR)%$(AUX_EXT): $(IN_DIR)%.c
	$(MYCC) $(DEFINES) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(OPTIMIZE_FLAGS) $(PREDEF) $(INCLUDE_DIRS) $(MYCFLAGS) -c "$<" -o "$@"

$(AUX_DIR)%$(AUX_EXT): $(IN_DIR)%.cpp
	$(MYCXX) $(DEFINES) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(OPTIMIZE_FLAGS) $(PREDEF) $(INCLUDE_DIRS) $(MYCXXFLAGS) -c "$<" -o "$@"

$(AUX_DIR)%$(AUX_EXT): $(IN_DIR)%.f
	$(FF) $(DEFINES) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(OPTIMIZE_FLAGS) $(PREDEF) $(INCLUDE_DIRS) $(CFLAGS) -c "$<" -o "$@"

asm: mkdir $(IN_DIR)$(ASSEMBLER_BASENAME)
	$(eval OPTIMIZE_FLAGS := -O0)
	$(MYCC) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(OPTIMIZE_FLAGS) $(CFLAGS) -S "$(IN_DIR)$(ASSEMBLE_BASENAME)" -o "$(OUT_DIR)$(ASSEMBLE_BASENAME).s"

clean:
	rm -rf "$(AUX_DIR)" "$(OUT)"

debug: clean set_debug_flags all
	gdb $(OUT)

mkdir:
	mkdir -p "$(AUX_DIR)"
	mkdir -p "$(OUT_DIR)"

profile: clean set_profile_flags all run
	mv -f gmon.out "$(OUT_DIR)"
	gprof -b $(OUT) "$(OUT_DIR)"gmon.out | tee "$(OUT).profile_out" | less

set_debug_flags:
	$(eval DEBUG_FLAGS := -ggdb3)
	$(eval DEBUG_DEFINE := -DDEBUG)
	$(eval OPTIMIZE_FLAGS := -O0)

set_profile_flags:
	$(eval PROFILE_FLAGS := -p -pg)
	$(eval PROFILE_DEFINE := -DPROFILE)
	#$(eval OPTIMIZE_FLAGS := )

run: all
	cd $(OUT_DIR) && ./$(OUT_BASENAME) $(RUN_ARGS)

-include Makefile_targets
