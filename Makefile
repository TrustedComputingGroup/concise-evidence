.DEFAULT_GOAL := check

SHELL := /bin/bash

CE_DIR := ./
IMPORTS_DIR := $(CE_DIR)imports/
EXPORTS_DIR := $(CE_DIR)exports/

include tools.mk
include funcs.mk

# Get imports frags - no dependencies
include $(IMPORTS_DIR)import-frags.mk
IMPORT_DEPS := $(addprefix $(IMPORTS_DIR), $(IMPORT_FRAGS))
COSE:=cose
SPDM:=spdm
CE:=ce
COMIDX:=comidx
EAT:=eat
check:: check-$(COSE) check-$(COSE)-examples
check:: check-$(EAT) check-$(EAT)-examples
check:: check-$(COMIDX) check-$(COMIDX)-examples
check:: check-$(SPDM) check-$(SPDM)-examples
check:: check-$(CE) check-$(CE)-examples
check:: export-all

include $(CE_DIR)ce-frags.mk
CE_DEPS := $(addprefix $(CE_DIR), $(CE_FRAGS))

SPDM_START := spdm-toc
SPDM_FRAGS += $(CE_DEPS)
SPDM_FRAGS += $(IMPORT_DEPS)

SPDM_EXAMPLES := $(wildcard examples/spdm-*.diag) # spdm toc example filenames have 'spdm-' prefix

$(eval $(call cddl_check_template,$(SPDM),$(SPDM_FRAGS),$(SPDM_EXAMPLES),$(SPDM_START)))

EV_START := tagged-concise-evidence
EV_FRAGS += $(CE_DEPS)
EV_FRAGS += $(IMPORT_DEPS)

EV_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,$(CE),$(EV_FRAGS),$(EV_EXAMPLES),$(EV_START)))

COMID_X_START := concise-mid-tag
COMID_X_FRAGS += $(CE_DEPS)
COMID_X_FRAGS += $(IMPORT_DEPS)

COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # concise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,$(COMIDX),$(COMID_X_FRAGS),$(COMID_X_EXAMPLES),$(COMID_X_START)))

EAT_START := cwt-eat
EAT_FRAGS += $(CE_DEPS)
EAT_FRAGS += $(IMPORT_DEPS)
EAT_FRAGS += cwt-eat.cddl

EAT_EXAMPLES := $(wildcard examples/eat-*.diag) # eat example filenames have 'eat-' prefix

$(eval $(call cddl_check_template,$(EAT),$(EAT_FRAGS),$(EAT_EXAMPLES),$(EAT_START)))

COSE_START := signed-cwt
COSE_FRAGS += $(CE_DEPS)
COSE_FRAGS += $(IMPORT_DEPS)
COSE_FRAGS += cwt-eat.cddl

COSE_EXAMPLES := $(wildcard examples/cose-*.diag) # signed cwt example filenames have 'cose-' prefix

$(eval $(call cddl_check_template,$(COSE),$(COSE_FRAGS),$(COSE_EXAMPLES),$(COSE_START)))

$(IMPORT_DEPS): check-imports

check-imports:
	$(MAKE) -C $(IMPORTS_DIR)

# Make exports - used by cddl-releases
$(eval $(call cddl_exp_template,coev,$(CE_DEPS),$(EXPORTS_DIR),$(IMPORT_FRAGS)))
AUTOGEN_FRAGS := $(addprefix $(CE_DIR), $(COSE)-autogen.cddl)
AUTOGEN_FRAGS += $(addprefix $(CE_DIR), $(SPDM)-autogen.cddl)
AUTOGEN_FRAGS += $(addprefix $(CE_DIR), $(CE)-autogen.cddl)
AUTOGEN_FRAGS += $(addprefix $(CE_DIR), $(COMIDX)-autogen.cddl)
AUTOGEN_FRAGS += $(addprefix $(CE_DIR), $(EAT)-autogen.cddl)

AUTOGEN_EXPORTS := $(addprefix $(EXPORTS_DIR), $(COSE)-autogen.cddl)
AUTOGEN_EXPORTS += $(addprefix $(EXPORTS_DIR), $(SPDM)-autogen.cddl)
AUTOGEN_EXPORTS += $(addprefix $(EXPORTS_DIR), $(CE)-autogen.cddl)
AUTOGEN_EXPORTS += $(addprefix $(EXPORTS_DIR), $(COMIDX)-autogen.cddl)
AUTOGEN_EXPORTS += $(addprefix $(EXPORTS_DIR), $(EAT)-autogen.cddl)

export-all: exp-coev check-$(COSE) check-$(COMIDX) check-$(SPDM) check-$(CE) check-$(EAT)
	cp $(AUTOGEN_FRAGS) $(EXPORTS_DIR)
CLEANFILES += $(AUTOGEN_EXPORTS)

clean: ; rm -f $(CLEANFILES); $(MAKE) -C $(IMPORTS_DIR) clean
