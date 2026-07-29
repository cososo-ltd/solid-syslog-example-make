# Stage FatFs so ff.h's `#include "ffconf.h"` resolves to our integrator config.
# GCC's "" lookup checks the including file's own directory first, so colocating
# the upstream ff.c/ff.h/diskio.h with our ffconf.h is how our config wins.

FATFS_DIR   := $(THIRD_PARTY)/fatfs
FATFS_STAGE := $(BUILD)/fatfs

FATFS_STAGED_HEADERS := $(FATFS_STAGE)/ff.h $(FATFS_STAGE)/diskio.h $(FATFS_STAGE)/ffconf.h
FATFS_OBJ            := $(OBJ_DIR)/fatfs/ff.o

FATFS_INCLUDES := -I$(FATFS_STAGE)

$(FATFS_STAGE)/ffconf.h: $(APP_DIR)/config/ffconf.h
	@mkdir -p $(@D)
	cp $< $@

$(FATFS_STAGE)/%: $(FATFS_DIR)/source/%
	@mkdir -p $(@D)
	cp $< $@
