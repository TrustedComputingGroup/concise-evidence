.DEFAULT_GOAL := check

SHELL := /bin/bash

CORIM_DIR_OLD := ietf-corim-cddl
CORIM_DIR := draft-ietf-rats-corim/cddl

CORIM_DEPS :=
CORIM_DEPS += $(CORIM_DIR)/comid-autogen.cddl
CORIM_DEPS += $(CORIM_DIR)/corim.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-code-points.cddl

include $(CORIM_DIR)/tools.mk
include $(CORIM_DIR)/funcs.mk

$(CORIM_DEPS): ; $(MAKE) -C $(CORIM_DIR)

check:: check-spdm check-spdm-examples
check:: check-comidx check-comidx-examples
check:: check-ce check-ce-examples

SPDM_FRAGS := spdm-start.cddl
SPDM_FRAGS += spdm-toc.cddl
SPDM_FRAGS += toc-code-points.cddl
SPDM_FRAGS += concise-evidence.cddl
SPDM_FRAGS += ce-code-points.cddl
SPDM_FRAGS += comid-extensions.cddl
SPDM_FRAGS += comid-extn-code-points.cddl
SPDM_FRAGS += $(CORIM_DEPS)

SPDM_EXAMPLES := $(wildcard examples/spdm-*.diag) # spdm toc example filenames have 'spdm-' prefix

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES)))

CE_FRAGS := ce-start.cddl
CE_FRAGS += concise-evidence.cddl
CE_FRAGS += ce-code-points.cddl
CE_FRAGS += comid-extensions.cddl
CE_FRAGS += comid-extn-code-points.cddl
CE_FRAGS += $(CORIM_DEPS)

CE_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,ce,$(CE_FRAGS),$(CE_EXAMPLES)))

COMID_X_FRAGS := comid-x-start.cddl
COMID_X_FRAGS += $(CORIM_DEPS)
COMID_X_FRAGS += comid-extensions.cddl
COMID_X_FRAGS += comid-extn-code-points.cddl

COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # concise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,comidx,$(COMID_X_FRAGS),$(COMID_X_EXAMPLES)))

clean: ; $(RM) $(CLEANFILES)

clean-extra: clean ; $(MAKE) -C $(CORIM_DIR) clean
