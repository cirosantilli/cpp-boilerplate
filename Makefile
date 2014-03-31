# `make help` for documentation.

-include Makefile_params

# Basename without extension of the file to generate assembly code for:
TMP_DIR 				?= _tmp/
TMP_EXT 				?= .o
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
RUN						?= $(OUT_BASENAME_NOEXT)
OUT_EXT 				?=
PROFILE_DEFINE 			?=
PROFILE_FLAGS 			?=

INS 		:= $(wildcard $(IN_DIR)*$(IN_EXT))
INS_NODIR 	:= $(notdir $(INS))
TMPS_NODIR	:= $(INS_NODIR:$(IN_EXT)=$(TMP_EXT))
TMPS		:= $(addprefix $(TMP_DIR),$(TMPS_NODIR))
OUT_BASENAME:= $(OUT_BASENAME_NOEXT)$(OUT_EXT)
OUT			:= $(OUT_DIR)$(OUT_BASENAME)

.PHONY: all assembler clean deps debug set_debug_flags help mkdir profile set_profile_flags test

all: mkdir $(OUT)

$(OUT): $(TMPS)
	$(MYCXX) $(PROFILE_FLAGS) $^ -o "$@" $(LIBS)

$(TMP_DIR)%$(TMP_EXT): $(IN_DIR)%.c
	$(MYCC) $(DEFINES) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(OPTIMIZE_FLAGS) $(PREDEF) $(INCLUDE_DIRS) $(MYCFLAGS) -c "$<" -o "$@"

$(TMP_DIR)%$(TMP_EXT): $(IN_DIR)%.cpp
	$(MYCXX) $(DEFINES) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(OPTIMIZE_FLAGS) $(PREDEF) $(INCLUDE_DIRS) $(MYCXXFLAGS) -c "$<" -o "$@"

$(TMP_DIR)%$(TMP_EXT): $(IN_DIR)%.f
	$(FF) $(DEFINES) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(OPTIMIZE_FLAGS) $(PREDEF) $(INCLUDE_DIRS) $(CFLAGS) -c "$<" -o "$@"

asm: mkdir
	$(eval OPTIMIZE_FLAGS := -O0)
	$(MYCC) $(PROFILE_DEFINE) $(PROFILE_FLAGS) $(DEBUG_DEFINE) $(DEBUG_FLAGS) $(OPTIMIZE_FLAGS) $(CFLAGS) -fverbose-asm -Wa,-adhln "$(IN_DIR)$(RUN)$(IN_EXT)" $(LIBS) -o $(TMP_DIR)asm$(TMP_EXT)\

clean:
	rm -rf "$(TMP_DIR)" "$(OUT)"

debug: clean set_debug_flags all
	gdb $(OUT)

mkdir:
	mkdir -p "$(TMP_DIR)" "$(OUT_DIR)"

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

test: all
	./test $(OUT_DIR) $(OUT_BASENAME)

-include Makefile_targets

help:
	@echo 'Compile all files with extension IN_EXT in directory IN_DIR into or into a single output file.'
	@echo 'IN_EXT can be either of: `.cpp`, `.c` or `.f`. The compiler is chosen accordingly.'
	@echo ''
	@echo '# Most useful invocations'
	@echo ''
	@echo 'Build:'
	@echo ''
	@echo '    make'
	@echo ''
	@echo 'Build and run output:'
	@echo ''
	@echo '    make run'
	@echo ''
	@echo '# Targets'
	@echo ''
	@echo 'all ................. Build all.'
	@echo 'asm [RUN=name] ...... BROKEN Print generated assembly code for the file with given basename without extension.'
	@echo 'clean ............... Clean built files.'
	@echo 'debug ............... Run with `gdb`.'
	@echo 'help ................ Print help to stdout.'
	@echo 'profile ............. Run with `gprof`.'
	@echo 'run ................. Run a file with the given basename or the default not given.'
	@echo 'test ................ Run `./test <output-directory> <output-basename>`'
