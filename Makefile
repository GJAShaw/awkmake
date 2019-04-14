# ------------------------------------------------------------------------------
# file: Makefile
# type: GNU makefile
# project: gawkmake
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
.PHONY: all
all: application

# --------------------------------------
# .ONESHELL
# --------------------------------------
.PHONY: .ONESHELL
.ONESHELL:

# --------------------------------------
# application
# --------------------------------------
.PHONY: application
application: $(build_mk)
	@$(MAKE) --no-print-directory -f $(build_mk)

# --------------------------------------
# buildmk
# --------------------------------------
.PHONY: buildmk
buildmk: $(build_mk)
$(build_mk): $(build_tacl) $(taclToMake_awk) $(library_awk)
	@echo "Building $@"
	@$(script_dir)/$(taclToMake_awk) < $(build_tacl) > $@

# --------------------------------------
# cleanapp
# --------------------------------------
.PHONY: cleanapp
cleanapp: $(build_mk)
	@$(MAKE) -f $(build_mk) clean

# --------------------------------------
# clean
# --------------------------------------
.PHONY: clean
clean:
	@echo "Deleting all targets and intermediate files"
	-@$(RM) $(targets) > /dev/null 2>&1
	@if [ -f $(build_mk) ]; then \
	  $(MAKE) --no-print-directory -f $(build_mk) clean; \
	fi > /dev/null 2>&1

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
