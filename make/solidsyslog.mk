# SolidSyslog. The library ships the source lists and include sets; naming the
# platforms is the whole of the selection, and each adapter gates itself on the
# upstream option it needs.
# https://docs.cososo.co.uk/solid-syslog/getting-started/#path-b--non-cmake-integrator-the-manifest

# The pin is a commit SHA in solid-syslog.pin, fetched into a directory named
# after it, so a changed pin is a fresh fetch rather than a stale tree reused.
SOLIDSYSLOG_PIN := $(strip $(file < solid-syslog.pin))
SOLIDSYSLOG_DIR := $(BUILD)/_deps/solid-syslog-$(SOLIDSYSLOG_PIN)

$(SOLIDSYSLOG_DIR)/solidsyslog.mk:
	rm -rf $(SOLIDSYSLOG_DIR)
	git init -q $(SOLIDSYSLOG_DIR)
	git -C $(SOLIDSYSLOG_DIR) fetch -q --depth 1 https://github.com/cososo-ltd/solid-syslog.git $(SOLIDSYSLOG_PIN)
	git -C $(SOLIDSYSLOG_DIR) checkout -q FETCH_HEAD

SOLIDSYSLOG_PLATFORMS := LwipRaw StdAtomic FreeRtos FatFs MbedTls
include $(SOLIDSYSLOG_DIR)/solidsyslog.mk

SOLIDSYSLOG_LIB := $(BUILD)/libSolidSyslog.a

SOLIDSYSLOG_CORE_OBJS     := $(SOLIDSYSLOG_CORE_SRCS:%.c=$(OBJ_DIR)/%.o)
SOLIDSYSLOG_PLATFORM_OBJS := $(SOLIDSYSLOG_PLATFORM_SRCS:%.c=$(OBJ_DIR)/%.o)

# Consumed via #include, so the value has to reach the compiler as a quoted C
# string literal — escaped rather than single-quoted, and absolute, because Core
# compiles without our include path on it.
SOLIDSYSLOG_USER_TUNABLES := -DSOLIDSYSLOG_USER_TUNABLES_FILE=\"$(CURDIR)/$(APP_DIR)/config/solid_syslog_tunables.h\"

# Every object that includes a SolidSyslog header needs it: the tunables change
# struct sizes, so Core, the platforms and our own code must agree on them.
$(SOLIDSYSLOG_CORE_OBJS): CFLAGS := $(COMMON_CFLAGS) $(SOLIDSYSLOG_CORE_INCLUDES) $(SOLIDSYSLOG_USER_TUNABLES)

$(SOLIDSYSLOG_LIB): $(SOLIDSYSLOG_CORE_OBJS)
	@mkdir -p $(@D)
	$(AR) rcs $@ $^
