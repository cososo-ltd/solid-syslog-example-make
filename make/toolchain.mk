# The cross toolchain and the three flag sets: upstream sources, our own, and
# mbedTLS. They differ only in warnings and include paths — the architecture and
# optimisation flags are shared, because a figure is only comparable between
# stages if every object was built the same way.

CROSS_COMPILE ?= arm-none-eabi-
CC  := $(CROSS_COMPILE)gcc
AR  := $(CROSS_COMPILE)ar

ARCH_FLAGS := -mcpu=cortex-m3 -mthumb

COMMON_CFLAGS := $(ARCH_FLAGS) -ffunction-sections -fdata-sections -fno-common -Os -DNDEBUG

APP_WARNINGS := -Wall -Wextra

UPSTREAM_WARNINGS := \
	-Wno-unused-parameter -Wno-unused-but-set-variable -Wno-implicit-fallthrough \
	-Wno-array-bounds -Wno-conversion -Wno-sign-conversion -Wno-shadow -Wno-pedantic

LDFLAGS := $(ARCH_FLAGS) \
	-T$(APP_DIR)/platform/mps2-an385.ld \
	--specs=nano.specs --specs=nosys.specs \
	-Wl,--gc-sections \
	-Wl,-Map=$(ELF).map
