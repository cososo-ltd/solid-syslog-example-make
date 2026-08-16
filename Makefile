# The device image — FreeRTOS + lwIP + mbedTLS + FatFs on QEMU mps2-an385
# (Cortex-M3). Upstream code comes from the pinned submodules under
# third_party/; the toolchain and QEMU come from the
# ghcr.io/cososo-ltd/cpputest-freertos-cross container. Drive it with ./run.sh.
#
#   make        build build/baseline.elf
#   make size   section sizes of the image
#   make clean  discard everything this Makefile built

BUILD       := build
OBJ_DIR     := $(BUILD)/obj
APP_DIR     := app
THIRD_PARTY := third_party
ELF         := $(BUILD)/baseline.elf

# Before the includes: make takes the first rule it reads as the default goal,
# and the ones below build parts.
.PHONY: all size clean
all: $(ELF)

# FreeRTOS, lwIP and SolidSyslog are submodules; mbedTLS and FatFs are in the
# tree. See third_party/README.md for why the mechanism differs by project.
MISSING := $(strip $(foreach d,FreeRTOS-Kernel lwip solid-syslog, \
	$(if $(wildcard $(THIRD_PARTY)/$(d)/*),,$(d))))
ifneq ($(MISSING),)
$(error empty submodule(s): $(MISSING) — run `git submodule update --init --recursive`)
endif

include make/toolchain.mk
include make/freertos.mk
include make/lwip.mk
include make/fatfs.mk
include make/mbedtls.mk
include make/solidsyslog.mk

APP_SRCS := \
	$(APP_DIR)/main.c \
	$(APP_DIR)/sim/SimulatedExistingApp.c \
	$(APP_DIR)/sim/SimulatedBrokerSession.c \
	$(APP_DIR)/tasks/LogTask.c \
	$(APP_DIR)/tasks/ServiceTask.c \
	$(APP_DIR)/measure/Measure.c \
	$(APP_DIR)/measure/Baseline.c \
	$(APP_DIR)/platform/Startup.c \
	$(APP_DIR)/platform/CmsdkUart.c \
	$(APP_DIR)/platform/DeviceClock.c \
	$(APP_DIR)/platform/DeviceCertStore.c \
	$(APP_DIR)/platform/Syscalls.c \
	$(APP_DIR)/platform/SemihostingExit.c \
	$(APP_DIR)/platform/SemihostingIo.c \
	$(APP_DIR)/net/EthernetIf.c \
	$(APP_DIR)/storage/diskio.c \
	$(APP_DIR)/storage/SemihostingDisk.c \
	$(APP_DIR)/syslog/SyslogErrorHandler.c

UPSTREAM_SRCS := \
	$(FREERTOS_SRCS) \
	$(LWIP_SRCS) \
	$(APP_DIR)/net/smsc9220/smsc9220_eth_drv.c \
	$(APP_DIR)/storage/ffsystem.c

APP_OBJS      := $(APP_SRCS:%.c=$(OBJ_DIR)/%.o)
UPSTREAM_OBJS := $(UPSTREAM_SRCS:%.c=$(OBJ_DIR)/%.o) $(FATFS_OBJ)

APP_INCLUDES := \
	-I$(APP_DIR) \
	-I$(APP_DIR)/config \
	-I$(APP_DIR)/sim \
	-I$(APP_DIR)/tasks \
	-I$(APP_DIR)/measure \
	-I$(APP_DIR)/net \
	-I$(APP_DIR)/net/smsc9220 \
	-I$(APP_DIR)/platform \
	-I$(APP_DIR)/storage \
	-I$(APP_DIR)/syslog \
	$(FREERTOS_INCLUDES) $(LWIP_INCLUDES) $(FATFS_INCLUDES) $(MBEDTLS_INCLUDES) \
	$(SOLIDSYSLOG_INCLUDES)

UPSTREAM_INCLUDES := \
	-I$(APP_DIR)/config \
	-I$(APP_DIR)/net/smsc9220 \
	$(FREERTOS_INCLUDES) $(LWIP_INCLUDES) $(FATFS_INCLUDES)

# app/sim includes <mbedtls/ssl.h> and must see the same user config as the
# library, or context struct sizes diverge between consumer and library.
# The staged FatFs headers have to exist before anything that includes them
# compiles; -MMD tracks them properly from then on.
$(APP_OBJS) $(UPSTREAM_OBJS) $(SOLIDSYSLOG_PLATFORM_OBJS): | $(FATFS_STAGED_HEADERS)

$(APP_OBJS) $(SOLIDSYSLOG_PLATFORM_OBJS): CFLAGS := $(COMMON_CFLAGS) $(APP_WARNINGS) $(APP_INCLUDES) $(MBEDTLS_USER_CONFIG)
$(UPSTREAM_OBJS): CFLAGS := $(COMMON_CFLAGS) $(UPSTREAM_WARNINGS) $(UPSTREAM_INCLUDES)

# Our objects, the upstream ones and the platform packs link in loose; mbedTLS
# and SolidSyslog Core link as archives.
# Under --gc-sections that is not a free choice: the linker takes every loose
# object and then discards unreachable sections, but pulls an archive member in
# only if it resolves something. Same sources, different image.
$(ELF): $(APP_OBJS) $(UPSTREAM_OBJS) $(SOLIDSYSLOG_PLATFORM_OBJS) $(SOLIDSYSLOG_LIB) \
        $(MBEDTLS_LIBS) $(APP_DIR)/platform/mps2-an385.ld
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $(APP_OBJS) $(UPSTREAM_OBJS) $(SOLIDSYSLOG_PLATFORM_OBJS) \
		$(SOLIDSYSLOG_LIB) $(MBEDTLS_LIBS) -o $@

# Every object depends on the makefiles, so a changed flag rebuilds what it
# changed rather than being linked into a stale image.
$(OBJ_DIR)/%.o: %.c $(MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

$(FATFS_OBJ): $(FATFS_STAGE)/ff.c $(MAKEFILE_LIST)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

size: $(ELF)
	$(CROSS_COMPILE)size $(ELF)

clean:
	rm -rf $(BUILD)
	$(MAKE) -C $(MBEDTLS_DIR)/library clean

-include $(APP_OBJS:.o=.d) $(UPSTREAM_OBJS:.o=.d) \
	$(SOLIDSYSLOG_CORE_OBJS:.o=.d) $(SOLIDSYSLOG_PLATFORM_OBJS:.o=.d)
