.DEFAULT_GOAL := check

SHELL := /bin/bash

include ../tools.mk
include ../funcs.mk

CORIM := corim-autogen

check:: get-$(CORIM)

# Get corim-autogen.cddl
CORIM_REPO := https://github.com/ietf-rats-wg/
CORIM_DL := draft-ietf-rats-corim/releases/download/
CORIM_TAG := cddl-8c267cd
$(eval $(call get_cddl_release,$(CORIM),$(CORIM_REPO),$(CORIM_DL),$(CORIM_TAG)))

CLEANFILES += $(CORIM).cddl

clean: ; rm $(CLEANFILES)