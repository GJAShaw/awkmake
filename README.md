# gawkmake

Using GAWK to build a GNU Makefile from a TACL script

## build.tacl - source
TACL script defining source, targets, dependencies and build methods for a project in the Guardian filesystem

## build.tacl - target
GNU Makefile created from the contents of build.tacl

## createBuildmk.awk
GAWK script to read build.tacl and create build.mk

## library.awk
GAWK script defining functions used by createBuildmk.awk

## Makefile
Master GNU Makefile to control the build of build.mk. Could easily be extended to invoke build.mk.

## src directory
Contains source for a simple "Hello, world!" project in the TAL language, which would be built using build.mk. Each subdirectory in src should be mapped in build.tacl to a subvolume in the Guardian filesystem.
