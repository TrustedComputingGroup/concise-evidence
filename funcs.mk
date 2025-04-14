%.cbor: %.diag ; $(diag2cbor) $< > $@

# $1: label
# $2: cddl fragments
# $3: diag test files
# $4: start string
define cddl_check_template

check-$(1): $(1)-autogen.cddl
	$$(cddl) $$< g 1

.PHONY: check-$(1)

$(1)-autogen.cddl: $(2)
	$(cddlc) -2tcddl $$^ --start=$(4) > $$@

CLEANFILES += $(1)-autogen.cddl

check-$(1)-examples: $(1)-autogen.cddl $(3:.diag=.cbor)
	@for f in $(3:.diag=.cbor); do \
		echo ">> validating $$$$f against $$<" ; \
		$$(cddl) $$< validate $$$$f &>/dev/null || exit 1 ; \
		echo ">> saving prettified CBOR to $$$${f%.cbor}.pretty" ; \
		$$(cbor2pretty) $$$$f > $$$${f%.cbor}.pretty ; \
	done

.PHONY: check-$(1)-examples

CLEANFILES += $(3:.diag=.cbor)
CLEANFILES += $(3:.diag=.pretty)

endef # cddl_check_template

# $(1) - export label
# $(2) - cddl fragments 
# $(3) - export directory
# $(4) - import dependencies
define cddl_exp_template

exp-$(1): $(3)$(1).cddl
	echo ">>> Creating exportable cddl file" ;

.PHONY: exp-$(1)

$(3)$(1).cddl: $(2)
	echo -e "; This cddl file depends on these cddl files: "$(4)"\n" > $$@
	@for f in $$^ ; do \
		( grep -v '^;' $$$$f ; echo ) ; \
	done >> $$@

CLEANFILES += $(3)$(1).cddl

endef # cddl_exp_template

# $(1) - imported cddl file name without .cddl
# $(2) - github url
# $(3) - download location
# $(4) - cddl-xxxx tag name
define get_cddl_release

get-$(1): $(1).cddl
	echo "Fetched cddl-release: " $$^

$(1).cddl:
	@{ \
	$$(curl) -LO $$(join $(2), $$(join $(3), $$(join $(4)/, $$@))); \
	sed -i.bak '/^@\.start\.@/d' $$@; \
	}

.PHONY: get-$(1)
CLEANFILES += $(1).cddl.bak
endef # get_cddl_release