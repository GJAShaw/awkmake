# ------------------------------------------------------------------------------
# file: Makefile
# type: GNU makefile
# project: awkmake
# ****TODO
# 1. derive server TACL name, so it can be put in build.mk
# 2. work out where (i.e. in which Makefile) to put these things:
#   - server TACL & wedge startup
#   - xfer, cp, ctoedit and load of build.tacl
#   - execution of define_everything
#   - $(MAKE) -f build.mk
#   - shutdown of server TACL and wedge
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# variables
# ------------------------------------------------------------------------------

# source - build_tacl
build_tacl := build.tacl

# scripts used to create targets
script_dir := script
library_awk := library.awk
taclToMake_awk := taclToMake.awk
vpath %.awk $(script_dir)

# target files
build_mk := build.mk

# targets list, for $(RM)
targets :=
targets +=\
$(build_mk)

# miscellaneous
RM := rm -fR

# ------------------------------------------------------------------------------
# rules
# ------------------------------------------------------------------------------

# --------------------------------------
# all
# --------------------------------------
all: $(build_mk)

# --------------------------------------
# .ONESHELL
# --------------------------------------
.ONESHELL:

# --------------------------------------
# .PHONY
# --------------------------------------
.PHONY: .ONESHELL all clean

# --------------------------------------
# build_mk
# --------------------------------------
$(build_mk): $(build_tacl) $(taclToMake_awk) $(library_awk)
	@echo "Building $@"
	@$(script_dir)/$(taclToMake_awk) < $(build_tacl) > $@ #2> /dev/null

# --------------------------------------
# clean
# --------------------------------------
clean:
	@echo "Deleting all targets and intermediate files"
	-@$(RM) $(targets)

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
