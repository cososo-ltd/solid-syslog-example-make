# mbedTLS ships its own Makefile, so it is consumed as a subproject with the
# toolchain and flags overridden rather than as a source list. It is the release
# tarball rather than a git checkout, which is what makes the five sources it
# generates present rather than generated — see third_party/README.md.
# https://github.com/Mbed-TLS/mbedtls/blob/v3.6.2/README.md

MBEDTLS_DIR := $(THIRD_PARTY)/mbedtls
MBEDTLS_LIBS := \
	$(MBEDTLS_DIR)/library/libmbedtls.a \
	$(MBEDTLS_DIR)/library/libmbedx509.a \
	$(MBEDTLS_DIR)/library/libmbedcrypto.a

MBEDTLS_INCLUDES := -I$(MBEDTLS_DIR)/include

# MBEDTLS_USER_CONFIG_FILE is consumed via #include, so the value must reach the
# compiler as a quoted C string literal. Escaped rather than single-quoted: on
# the way to the library it passes through two shells, this recipe's and the
# sub-make's, and a quote that closes early takes the string literal with it.
# Absolute, because the library builds in its own directory.
MBEDTLS_USER_CONFIG := -DMBEDTLS_USER_CONFIG_FILE=\"$(CURDIR)/$(APP_DIR)/config/mbedtls_user_config.h\"

MBEDTLS_CFLAGS := $(COMMON_CFLAGS) -std=c99 $(MBEDTLS_USER_CONFIG)

# Three of the five generated sources are guarded by mbedTLS's own GEN_FILES
# mechanism, which makes their prerequisites order-only so a file the release
# already ships is never rebuilt. The PSA driver wrappers are not: their
# prerequisites are ordinary, so they regenerate whenever the generator or its
# templates look newer. On a checkout that is exactly what they are — git writes
# library/ before scripts/ — so the build reaches for a generator, and its Python
# dependencies, that a release tarball exists to make unnecessary.
MBEDTLS_WRAPPERS := $(addprefix $(MBEDTLS_DIR)/library/psa_crypto_driver_wrappers, .h _no_static.c)

# The three archives by name rather than the `lib` target: `lib` also drops a
# test seedfile into tests/, which a library-only tree does not have.
.PHONY: mbedtls
mbedtls: $(BUILD)/mbedtls-cflags
	@touch $(MBEDTLS_WRAPPERS)
	$(MAKE) -C $(MBEDTLS_DIR)/library $(notdir $(MBEDTLS_LIBS)) CC=$(CC) AR=$(AR) \
		CFLAGS='$(MBEDTLS_CFLAGS)' WARNING_CFLAGS=-w

$(MBEDTLS_LIBS): mbedtls ;

# The library's Makefile compares timestamps, not flags, so a changed flag set
# would otherwise be linked in from objects built with the old one.
$(BUILD)/mbedtls-cflags: $(MAKEFILE_LIST)
	@mkdir -p $(@D)
	@echo '$(MBEDTLS_CFLAGS)' | cmp -s - $@ || \
		{ $(MAKE) -C $(MBEDTLS_DIR)/library clean; echo '$(MBEDTLS_CFLAGS)' > $@; }
	@touch $@
