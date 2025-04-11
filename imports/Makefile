.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

check:: corim-autogen.cddl

# Get corim-autogen.cddl
github := https://github.com/ietf-rats-wg/
corim_rel_dl := draft-ietf-rats-corim/releases/download/
corim_tag := cddl-8c267cd
corim_url := $(join $(github), $(join $(corim_rel_dl), $(corim_tag)))

corim-autogen.cddl: ; $(curl) -LO $(corim_url)/$@ ; grep -v '^@\.start\.@' $@ > $@.tmp ; mv $@.tmp $@

CLEANFILES += corim-autogen.cddl

clean: ; rm $(CLEANFILES)