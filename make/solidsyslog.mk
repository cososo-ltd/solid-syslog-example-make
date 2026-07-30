# SolidSyslog. The library ships the source lists and include sets; naming the
# platforms is the whole of the selection, and each adapter gates itself on the
# upstream option it needs.
# https://docs.cososo.co.uk/solid-syslog/getting-started/#path-b--non-cmake-integrator-the-manifest

SOLIDSYSLOG_PLATFORMS := LwipRaw
include $(THIRD_PARTY)/solid-syslog/solidsyslog.mk

SOLIDSYSLOG_LIB := $(BUILD)/libSolidSyslog.a

SOLIDSYSLOG_CORE_OBJS     := $(SOLIDSYSLOG_CORE_SRCS:%.c=$(OBJ_DIR)/%.o)
SOLIDSYSLOG_PLATFORM_OBJS := $(SOLIDSYSLOG_PLATFORM_SRCS:%.c=$(OBJ_DIR)/%.o)

$(SOLIDSYSLOG_CORE_OBJS): CFLAGS := $(COMMON_CFLAGS) $(SOLIDSYSLOG_CORE_INCLUDES)

$(SOLIDSYSLOG_LIB): $(SOLIDSYSLOG_CORE_OBJS)
	@mkdir -p $(@D)
	$(AR) rcs $@ $^
