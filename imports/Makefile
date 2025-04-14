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


CLEANFILES += corim-autogen.cddl

clean: ; rm $(CLEANFILES)