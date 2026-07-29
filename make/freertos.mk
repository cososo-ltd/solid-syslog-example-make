FREERTOS_DIR      := $(THIRD_PARTY)/FreeRTOS-Kernel
FREERTOS_PORT_DIR := $(FREERTOS_DIR)/portable/GCC/ARM_CM3

FREERTOS_SRCS := \
	$(FREERTOS_DIR)/tasks.c \
	$(FREERTOS_DIR)/queue.c \
	$(FREERTOS_DIR)/list.c \
	$(FREERTOS_DIR)/timers.c \
	$(FREERTOS_DIR)/event_groups.c \
	$(FREERTOS_PORT_DIR)/port.c \
	$(FREERTOS_DIR)/portable/MemMang/heap_1.c

FREERTOS_INCLUDES := -I$(FREERTOS_DIR)/include -I$(FREERTOS_PORT_DIR)
