.DEFAULT_GOAL := check

SHELL := /bin/bash

CORIM_DIR := ietf-corim-cddl
CORIM_DEPS := $(CORIM_DIR)/comid-autogen.cddl
CORIM_DEPS += $(CORIM_DIR)/corim.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-code-points.cddl

include $(CORIM_DIR)/tools.mk
include $(CORIM_DIR)/funcs.mk

$(CORIM_DEPS): ; $(MAKE) -C $(CORIM_DIR)

check:: check-spdm check-spdm-examples
check:: check-comid check-comid-examples

SPDM_FRAGS := spdm-toc.cddl
SPDM_FRAGS += ce-code-points.cddl
SPDM_FRAGS += comid-extensions.cddl
SPDM_FRAGS += comid-extn-code-points.cddl
SPDM_FRAGS += concise-evidence.cddl
SPDM_FRAGS += toc-code-points.cddl
SPDM_FRAGS += $(CORIM_DEPS)

SPDM_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES)))


COMID_X_FRAGS := $(CORIM_DIR)/comid-autogen.cddl
COMID_X_FRAGS += comid-extensions.cddl
COMID_X_FRAGS += comid-extn-code-points.cddl


COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # conscise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,comid,$(COMID_X_FRAGS),$(COMID_X_EXAMPLES)))

clean: ; $(RM) $(CLEANFILES)

clean-extra: clean ; $(MAKE) -C $(CORIM_DIR) clean
