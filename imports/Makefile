.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

check:: get-corim-autogen

# Get corim-autogen.cddl
CORIM := corim-autogen
CORIM_REPO := https://github.com/ietf-rats-wg/
CORIM_DL := draft-ietf-rats-corim/releases/download/
CORIM_TAG := cddl-8c267cd
$(eval $(call get_cddl_release,$(CORIM),$(CORIM_REPO),$(CORIM_DL),$(CORIM_TAG)))

# Get corim-autogen.cddl
#github := https://github.com/ietf-rats-wg/
#corim_rel_dl := draft-ietf-rats-corim/releases/download/
#corim_tag := cddl-8c267cd
#corim_url := $(join $(github), $(join $(corim_rel_dl), $(corim_tag)))

#corim-autogen.cddl: ; $(curl) -LO $(corim_url)/$@ ; grep -v '^@\.start\.@' $@ > $@.tmp ; mv $@.tmp $@

CLEANFILES += corim-autogen.cddl

clean: ; rm $(CLEANFILES)