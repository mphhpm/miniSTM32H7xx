##
##    Copyright (c) 2024 mphhpm.
##    Permission is hereby granted, free of charge, to any person obtaining
##    a copy of this software and associated documentation files (the "Software"),
##    to deal in the Software without restriction, including without limitation
##    the rights to use, copy, modify, merge, publish, distribute, sublicense,
##    and/or sell copies of the Software, and to permit persons to whom the Software
##    is furnished to do so, subject to the following conditions:
##
##    The above copyright notice and this permission notice shall be included in
##    all copies or substantial portions of the Software.
##
##    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
##    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
##    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
##    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
##    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
##    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##
##    Changes
##    1-1-2024: mphhpm: initial version

export Q=@
export MAKE_SYSTEM_DIR = $(abspath 3rd/stm32-make/src)
export PROJECT = ministm32h7xx
export DEVICE  = stm32h743vit6
export STARTUP_SCRIPT=$(abspath startup_stm32h743vitx.s)
export MCPU=cortex-m7
export MFPU=fpv5-d16
export LVGL_BUILD_DIR=$(abspath build/lvgl/$(DEVICE)/obj)
export LVGL_OUTPUT_DIR=$(abspath build/lvgl/$(DEVICE)/bin) 
export LVGL_PATH=$(abspath 3rd/lvgl)
export LVGL_CFLAGS = -I$(LVGL_PATH)
export LDFLAGS += -mcpu=$(MCPU) -mfpu=$(MFPU) -L$(LVGL_OUTPUT_DIR)
export CFLAGS  += -mcpu=$(MCPU) -mfpu=$(MFPU) -DLV_CONF_PATH=$(abspath lv_conf.h) $(LVGL_CFLAGS)
export CPPFLAGS+= -mcpu=$(MCPU) -mfpu=$(MFPU)
##
## lvgl

CFLAGSADD="-DSTM32H743xx -DTFT96"
##
all: build-lcd
	
build-lcd:
	$(Q)$(MAKE) --file Makefile.modules.mk BUILD_DIR=$(abspath build/sdk/hal/stm32h743/03-lcd_test\obj) \
				OUTPUT_DIR=$(abspath build/sdk/hal/stm32h743/03-lcd_test\bin) \
				MAKE_SYSTEM_DIR=$(MAKE_SYSTEM_DIR) PROJECT_DIR=$(abspath 3rd/MiniSTM32H7xx/sdk/hal/stm32h743/03-lcd_test) \
				CFLAGSADD=$(CFLAGSADD) PROJECT=lcd_test LDSCRIPT=$(abspath stm32h743vit6.ld)
				
clean-lcd:
	$(Q)$(MAKE) --file Makefile.modules.mk clean BUILD_DIR=$(abspath build/sdk/hal/stm32h743/03-lcd_test\obj) \
				OUTPUT_DIR=$(abspath 3rd/MiniSTM32H7xx/build/sdk/hal/stm32h743/03-lcd_test\bin) \
				PROJECT_DIR=$(abspath 3rd/MiniSTM32H7xx/sdk/hal/stm32h743/03-lcd_test) 

build-lvgl:
	$(Q)$(MAKE) -f lvgl.mk -j 8 BUILD_DIR=$(LVGL_BUILD_DIR) OUTPUT_DIR=$(LVGL_OUTPUT_DIR) LVGL_PATH=$(LVGL_PATH) DEVICE=$(DEVICE)

build_lvgl_demo:
	$(Q)$(MAKE) --file Makefile.modules.mk BUILD_DIR=$(abspath build/stm32h743/lvgl_demo/obj) \
				LV_CONF_PATH=$(abspath lv_conf.h) \
				OUTPUT_DIR=$(abspath build/stm32h743/lvgl_demo/bin) \
				LDLIBS=-lstm32h743vit6.lvgl \
				MAKE_SYSTEM_DIR=$(MAKE_SYSTEM_DIR) PROJECT_DIR=$(abspath lvgl/lvgl_demo) \
				CFLAGSADD=$(CFLAGSADD) \
				PROJECT=lvgl_demo LDSCRIPT=$(abspath stm32h743vit6.ld)

flash-lvgl_demo:
	st-flash --connect-under-reset --reset write build/stm32h743/lvgl_demo/bin/lvgl_demo-stm32h743vit6.bin 0x8000000
					
flash-lcd:
	st-flash --connect-under-reset --reset write build/sdk/hal/stm32h743/03-lcd_test\bin\lcd_test-stm32h743vit6.bin 0x8000000
	