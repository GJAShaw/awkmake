# ------------------------------------------------------------------------------
# file: Makefile
# type: GNU makefile
# project: awkmake
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# variables
# ------------------------------------------------------------------------------

# source - build_tacl
export build_tacl := build.tacl

# scripts used to create targets
script_dir := script
vpath %.awk $(script_dir)

# targets - makefiles and parts thereof
build_mk := build.mk
define_target_rules_mk := define_target_rules.mk
map_guardian180_to_guardian101_mk := map_guardian180_to_guardian101.mk
map_source_to_guardian180_mk := map_source_to_guardian180.mk

# concatenate the partials in the order you want their contents within build.mk
partial_makefiles :=
partial_makefiles +=\
$(define_target_rules_mk) \
$(map_guardian180_to_guardian101_mk) \
$(map_source_to_guardian180_mk)

# targets list, for $(RM)
targets :=
targets +=\
$(build_mk) \
$(partial_makefiles)

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
$(build_mk): $(partial_makefiles)
	@echo "Building $@"
	@cat $(partial_makefiles) > $@ #2> /dev/null

# --------------------------------------
# partial makefiles
# --------------------------------------
%.mk: $(build_tacl) %.awk
	@echo "Building $@"
	@$(script_dir)/$*.awk < $(build_tacl) > $@ #2> /dev/null

# --------------------------------------
# clean
# --------------------------------------
clean:
	@echo "Deleting all targets and intermediate files"
	-@$(RM) $(targets)

# ------------------------------------------------------------------------------
# EOF
# ------------------------------------------------------------------------------
