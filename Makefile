.DEFAULT_GOAL := check

SHELL := /bin/bash

IMPORTS_DIR := imports/
export EXPORTS_DIR := exports/
CE_DIR := ./

include tools.mk
include funcs.mk

# Get imports frags - no dependencies
include $(IMPORTS_DIR)import-frags.mk
IMPORT_DEPS := $(addprefix $(IMPORTS_DIR), $(IMPORT_FRAGS))

check:: check-cose check-cose-examples
check:: check-eat check-eat-examples
check:: check-comidx check-comidx-examples
check:: check-spdm check-spdm-examples
check:: check-ce check-ce-examples
check:: exp-coev

include $(CE_DIR)ce-frags.mk
CE_DEPS := $(addprefix $(CE_DIR), $(CE_FRAGS))

SPDM_START := spdm-toc
SPDM_FRAGS += $(CE_DEPS)
SPDM_FRAGS += $(IMPORT_DEPS)

SPDM_EXAMPLES := $(wildcard examples/spdm-*.diag) # spdm toc example filenames have 'spdm-' prefix

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES),$(SPDM_START)))

EV_START := tagged-concise-evidence
EV_FRAGS += $(CE_DEPS)
EV_FRAGS += $(IMPORT_DEPS)

EV_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,ce,$(EV_FRAGS),$(EV_EXAMPLES),$(EV_START)))

COMID_X_START := concise-mid-tag
COMID_X_FRAGS += $(CE_DEPS)
COMID_X_FRAGS += $(IMPORT_DEPS)

COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # concise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,comidx,$(COMID_X_FRAGS),$(COMID_X_EXAMPLES),$(COMID_X_START)))

EAT_START := cwt-eat
EAT_FRAGS += $(CE_DEPS)
EAT_FRAGS += $(IMPORT_DEPS)
EAT_FRAGS += cwt-eat.cddl

EAT_EXAMPLES := $(wildcard examples/eat-*.diag) # eat example filenames have 'eat-' prefix

$(eval $(call cddl_check_template,eat,$(EAT_FRAGS),$(EAT_EXAMPLES),$(EAT_START)))

COSE_START := signed-cwt
COSE_FRAGS += $(CE_DEPS)
COSE_FRAGS += $(IMPORT_DEPS)
COSE_FRAGS += cwt-eat.cddl

COSE_EXAMPLES := $(wildcard examples/cose-*.diag) # signed cwt example filenames have 'cose-' prefix

$(eval $(call cddl_check_template,cose,$(COSE_FRAGS),$(COSE_EXAMPLES),$(COSE_START)))

$(IMPORT_DEPS): check-imports

check-imports:
	$(MAKE) -C $(IMPORTS_DIR)

# Make coev.cddl export file - used by cddl-releases
$(eval $(call cddl_exp_template,coev,$(CE_DEPS),$(EXPORTS_DIR),$(IMPORT_FRAGS)))

clean: ; rm -f $(CLEANFILES); $(MAKE) -C $(IMPORTS_DIR) clean

exce: ce-autogen.cddl
	@echo -n "copying ce.cddl to exports"
	# @cp $(CE_DIR)/ce-autogen.cddl exports/ce.cddl
	$(eval $(call cddl_exports_template, exports/ce, $(CE_DEPS)))