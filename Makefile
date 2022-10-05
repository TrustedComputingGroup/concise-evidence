.DEFAULT_GOAL := check

SHELL := /bin/bash

CORIM_DIR_OLD := ietf-corim-cddl
CORIM_DIR := draft-ietf-rats-corim/cddl

CORIM_DEPS :=
CORIM_DEPS += $(CORIM_DIR)/attest-key-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/class-id-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/class-map.cddl
CORIM_DEPS += $(CORIM_DIR)/comid-entity-map.cddl
CORIM_DEPS += $(CORIM_DIR)/comid-role-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/concise-mid-tag.cddl
CORIM_DEPS += $(CORIM_DIR)/concise-swid-tag.cddl
CORIM_DEPS += $(CORIM_DIR)/concise-tag-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-entity-map.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-id-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-locator-map.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-map.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-meta-map.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-role-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/corim-signer-map.cddl
CORIM_DEPS += $(CORIM_DIR)/corim.cddl
CORIM_DEPS += $(CORIM_DIR)/cose-label-and-value.cddl
CORIM_DEPS += $(CORIM_DIR)/cose-sign1-corim.cddl
CORIM_DEPS += $(CORIM_DIR)/coswid-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/crypto-key-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/domain-dependency-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/domain-membership-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/domain-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/endorsed-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/entity-map.cddl
CORIM_DEPS += $(CORIM_DIR)/entity-name-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/environment-map.cddl
CORIM_DEPS += $(CORIM_DIR)/flags-map.cddl
CORIM_DEPS += $(CORIM_DIR)/group-id-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/identity-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/instance-id-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/ip-addr-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/linked-tag-map.cddl
CORIM_DEPS += $(CORIM_DIR)/mac-addr-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/measured-element-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/measurement-map.cddl
CORIM_DEPS += $(CORIM_DIR)/measurement-values-map.cddl
CORIM_DEPS += $(CORIM_DIR)/non-empty.cddl
CORIM_DEPS += $(CORIM_DIR)/oid.cddl
CORIM_DEPS += $(CORIM_DIR)/profile-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/protected-corim-header-map.cddl
CORIM_DEPS += $(CORIM_DIR)/raw-value.cddl
CORIM_DEPS += $(CORIM_DIR)/reference-triple-record.cddl
CORIM_DEPS += $(CORIM_DIR)/signed-corim.cddl
CORIM_DEPS += $(CORIM_DIR)/svn-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/tag-id-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/tag-identity-map.cddl
CORIM_DEPS += $(CORIM_DIR)/tag-rel-type-choice.cddl
CORIM_DEPS += $(CORIM_DIR)/tag-version-type.cddl
CORIM_DEPS += $(CORIM_DIR)/tagged-corim-map.cddl
CORIM_DEPS += $(CORIM_DIR)/tagged-int.cddl
CORIM_DEPS += $(CORIM_DIR)/triples-map.cddl
CORIM_DEPS += $(CORIM_DIR)/ueid.cddl
CORIM_DEPS += $(CORIM_DIR)/unprotected-corim-header-map.cddl
CORIM_DEPS += $(CORIM_DIR)/uuid.cddl
CORIM_DEPS += $(CORIM_DIR)/validity-map.cddl
CORIM_DEPS += $(CORIM_DIR)/version-map.cddl

#include $(CORIM_DIR)/tools.mk
include tools.mk
#include $(CORIM_DIR)/funcs.mk
include funcs.mk

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
SPDM_FRAGS += $(CORIM_DEPS)

SPDM_EXAMPLES := $(wildcard examples/spdm-*.diag) # spdm toc example filenames have 'spdm-' prefix

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES)))

CE_FRAGS := ce-start.cddl
CE_FRAGS += concise-evidence.cddl
CE_FRAGS += ce-code-points.cddl
CE_FRAGS += comid-extensions.cddl
CE_FRAGS += $(CORIM_DEPS)

CE_EXAMPLES := $(wildcard examples/ce-*.diag) # concise-evidence example filenames have 'ce-' prefix

$(eval $(call cddl_check_template,ce,$(CE_FRAGS),$(CE_EXAMPLES)))

COMID_X_FRAGS := comid-x-start.cddl
COMID_X_FRAGS += $(CORIM_DEPS)
COMID_X_FRAGS += comid-extensions.cddl

COMID_X_EXAMPLES := $(wildcard examples/comid-*.diag) # concise-mid-tag example filenames have 'comid-' prefix

$(eval $(call cddl_check_template,comidx,$(COMID_X_FRAGS),$(COMID_X_EXAMPLES)))

clean: ; $(RM) $(CLEANFILES)

clean-extra: clean ; $(MAKE) -C $(CORIM_DIR) clean
