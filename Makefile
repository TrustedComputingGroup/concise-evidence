.DEFAULT_GOAL := check

SHELL := /bin/bash

IMPORTS_DIR := imports/
export EXPORTS_DIR := exports/
CE_DIR := ./

include tools.mk
include funcs.mk

#
# manually link newly built corim dependencies to imports/corim-import.cddl
#
CORIM_IMPORT := $(addprefix $(IMPORTS_DIR), corim-import.cddl )

check:: check-comidx check-comidx-examples
check:: check-spdm check-spdm-examples
check:: check-ce check-ce-examples
check:: exp-ce

include $(CE_DIR)ce-frags.mk
CE_DEPS := $(addprefix $(CE_DIR), $(CE_FRAGS))

SPDM_FRAGS += $(CE_DEPS)
SPDM_FRAGS += $(CORIM_IMPORT)

SPDM_EXAMPLES := $(wildcard examples/spdm-*.diag) # spdm toc example filenames have 'spdm-' prefix

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES)))

EV_FRAGS := ce-start.cddl
EV_FRAGS += $(CE_DEPS)
EV_FRAGS += $(CORIM_IMPORT)

EV_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,ce,$(EV_FRAGS),$(EV_EXAMPLES)))

COMID_X_FRAGS := comid-x-start.cddl
COMID_X_FRAGS += $(CE_DEPS)
COMID_X_FRAGS += $(CORIM_IMPORT)

COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # concise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,comidx,$(COMID_X_FRAGS),$(COMID_X_EXAMPLES)))

# Make ce.cddl export file
$(eval $(call cddl_exp_template,ce,$(CE_DEPS)))

clean: ; rm -f $(CLEANFILES)

exce: ce-autogen.cddl
	@echo -n "copying ce.cddl to exports"
	# @cp $(CE_DIR)/ce-autogen.cddl exports/ce.cddl
	$(eval $(call cddl_exports_template, exports/ce, $(CE_DEPS)))