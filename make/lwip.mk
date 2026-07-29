# lwIP ships the source lists it wants you to use. LWIPDIR is the variable
# src/Filelists.mk reads. contrib has a Filelists.mk too, but it lists only the
# example applications — the FreeRTOS port is named here.

LWIP_DIR      := $(THIRD_PARTY)/lwip
LWIPDIR       := $(LWIP_DIR)/src
LWIP_PORT_DIR := $(LWIP_DIR)/contrib/ports/freertos

include $(LWIPDIR)/Filelists.mk

# IPv4 core plus the api set the NO_SYS=0 tcpip thread needs.
LWIP_SRCS := \
	$(COREFILES) \
	$(CORE4FILES) \
	$(APIFILES) \
	$(LWIPDIR)/netif/ethernet.c \
	$(LWIP_PORT_DIR)/sys_arch.c

LWIP_INCLUDES := -I$(LWIPDIR)/include -I$(LWIP_PORT_DIR)/include
