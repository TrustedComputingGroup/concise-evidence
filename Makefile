.DEFAULT_GOAL := check

CORIM_DIR := ietf-corim-cddl
CORIM_DEPS := $(foreach ca,comid,$(CORIM_DIR)/$(ca)-autogen.cddl)

include $(CORIM_DIR)/tools.mk
include $(CORIM_DIR)/funcs.mk

$(CORIM_DEPS): ; $(MAKE) -C $(CORIM_DIR)

check:: check-spdm

SPDM_FRAGS := spdm-toc.cddl
SPDM_FRAGS += ce-code-points.cddl
SPDM_FRAGS += comid-extensions.cddl
SPDM_FRAGS += comid-extn-code-points.cddl
SPDM_FRAGS += concise-evidence.cddl
SPDM_FRAGS += toc-code-points.cddl
SPDM_FRAGS += $(CORIM_DEPS)

SPDM_EXAMPLES := $(wildcard examples/*.diag)

$(eval $(call cddl_check_template,spdm,$(SPDM_FRAGS),$(SPDM_EXAMPLES)))

clean: ; $(RM) $(CLEANFILES)

clean-extra: clean ; $(MAKE) -C $(CORIM_DIR) clean
