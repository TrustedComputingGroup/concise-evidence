include ../tools.mk

github := https://github.com/ietf/
corim_rel_dl := draft-ietf-rats-corim/releases/download/
corim_tag := cddl-tbd
corim_url := $(join $(github), $(join $(corim_rel_dl), $(corim_tag)))

corim-autogen.cddl: ; $(curl) -LO $(corim_url)/$@

CLEANFILES += corim-autogen.cddl
