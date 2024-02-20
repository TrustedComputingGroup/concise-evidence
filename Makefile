.DEFAULT_GOAL := check

SHELL := /bin/bash

CORIM_DIR := draft-ietf-rats-corim/
CORIM_FRAGS_DIR := draft-ietf-rats-corim/cddl/
CE_DIR := ./

include $(CORIM_FRAGS_DIR)corim-frags.mk
CORIM_DEPS := $(addprefix $(CORIM_FRAGS_DIR), $(CORIM_FRAGS))

include tools.mk
include funcs.mk

$(CORIM_DEPS): ; $(MAKE) -C $(CORIM_DIR)

check:: check-comidx check-comidx-examples
check:: check-spdm check-spdm-examples
check:: check-ce check-ce-examples

include $(CE_DIR)ce-frags.mk
CE_DEPS := $(addprefix $(CE_DIR), $(CE_FRAGS))

SPDM_FRAGS := spdm-start.cddl
SPDM_FRAGS += $(CE_DEPS)
SPDM_FRAGS += $(CORIM_DEPS)

SPDM_EXAMPLES := $(wildcard examples/spdm-*.diag) # spdm toc example filenames have 'spdm-' prefix

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES)))

CE_FRAGS := ce-start.cddl
CE_FRAGS += $(CE_DEPS)
CE_FRAGS += $(CORIM_DEPS)

CE_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,ce,$(CE_FRAGS),$(CE_EXAMPLES)))

COMID_X_FRAGS := comid-x-start.cddl
COMID_X_FRAGS += $(CE_DEPS)
COMID_X_FRAGS += $(CORIM_DEPS)

COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # concise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,comidx,$(COMID_X_FRAGS),$(COMID_X_EXAMPLES)))

clean: ; rm -f $(CLEANFILES)

clean-extra: clean ; $(MAKE) -C $(CORIM_DIR) clean
