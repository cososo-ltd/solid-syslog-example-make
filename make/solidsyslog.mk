# SolidSyslog. The library ships the source lists and include sets; naming the
# platforms is the whole of the selection, and each adapter gates itself on the
# upstream option it needs.
# https://docs.cososo.co.uk/solid-syslog/getting-started/#path-b--non-cmake-integrator-the-manifest

SOLIDSYSLOG_PLATFORMS := LwipRaw Atomics
include $(THIRD_PARTY)/solid-syslog/solidsyslog.mk

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
