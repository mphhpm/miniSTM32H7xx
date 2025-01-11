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
##    2-Feb-2024: mphhpm: initial version
Q=@
ifndef MAKE_SYSTEM_DIR
$(error MAKE_SYSTEM_DIR is not set)
endif

##
## toolchain
include $(MAKE_SYSTEM_DIR)/Makefile.toolchain
include $(MAKE_SYSTEM_DIR)/Makefile.Flags

##
## files to be considered to compile
DEPDIR   ?= $(BUILD_DIR)/.deps
CFILES    = $(wildcard $(shell $(FIND) $(PROJECT_DIR) -type f -name "*.c"))
ASFILES   = $(STARTUP_SCRIPT)
CPPFILES += $(wildcard $(shell $(FIND) $(PROJECT_DIR) -type f -name "*.cpp"))

#LDLIBS     += -lstdc++
LDFLAGS    += -T$(LDSCRIPT) -L . 
LDFLAGS    += $(ARCH)
LDFLAGS    += -specs=nosys.specs
LDFLAGS    += -Wl,--gc-sections -Wl,-Map,$(OUTPUT_DIR)/$(PROJECT)-$(DEVICE).map
##
## dependencies
DEPFILES  = $(addprefix $(DEPDIR)/, $(notdir $(CFILES:%.c=$(DEPDIR)/%.d)), $(notdir $(CPPFILES:%.cpp=$(DEPDIR)/%.d)))
DEPFLAGS  = -MT $@ -MMD -MP -MF $(DEPDIR)/$(notdir $*).d
##
## search path
INCLUDES = $(patsubst %,-I%, $(sort  \
             $(dir \
               $(wildcard $(shell $(FIND) $(PROJECT_DIR)   -type f -name '*.h')) \
             )))

             
CPPFLAGS += -fno-rtti -fno-exceptions -fpermissive -felide-constructors -fno-use-cxa-atexit -ffunction-sections -fdata-sections -nostdlib  -DF_CLOCK=480000000
CPPFLAGS += $(DEPFLAGS) 
CPPFLAGS += $(INCLUDES)
CFLAGS   += $(INCLUDES) $(CFLAGSADD)
VPATH    += $(sort $(dir $(CFILES) $(CPPFILES) $(ASFILES)) .)

OBJS  = $(addprefix $(BUILD_DIR)/, $(sort $(notdir $(CFILES:%.c=$(BUILD_DIR)/%.o))))
OBJS += $(addprefix $(BUILD_DIR)/, $(sort $(notdir $(ASFILES:%.s=$(BUILD_DIR)/%.o))))
OBJS += $(addprefix $(BUILD_DIR)/, $(sort $(notdir $(CPPFILES:%.cpp=$(BUILD_DIR)/%.o))))

include $(MAKE_SYSTEM_DIR)/Makefile.rules

all:$(BUILD_DIR) $(OUTPUT_DIR) $(DEPDIR) $(OUTPUT_DIR)/$(PROJECT)-$(DEVICE).bin $(OUTPUT_DIR)/$(PROJECT)-$(DEVICE).list

$(OUTPUT_DIR)/$(PROJECT)-$(DEVICE).elf: $(OBJS) $(LDSCRIPT)
	$(Q)$(PRINTF) "  [LD]\t$(notdir $@)\n"
	$(Q)$(MKDIR) -p $(dir $@)
	$(Q)$(CXX) $(TGT_LDFLAGS) $(LDFLAGS) $(OBJS) $(LDLIBS) -o $@

$(DEPDIR) $(BUILD_DIR) $(OUTPUT_DIR): 
	$(Q)$(MKDIR) -p $@

$(DEPFILES): $(DEPDIR)

dump: $(OUTPUT_DIR)/$(PROJECT).elf
	$(Q)$(PRINTF) "  [OBJDUMP]\t$(notdir $@)\n"
	$(Q)$(MKDIR) -p $(dir $@)
	$(Q)$(OUTPUT_DIR) -h $(OUTPUT_DIR)/$(PROJECT).elf    
	$(Q)$(OUTPUT_DIR) -S $(OUTPUT_DIR)/$(PROJECT).elf > $(OUTPUT_DIR)/$(PROJECT).src   

clean:
	$(Q)$(PRINTF) "  [CLEAN]\t$@\n"
	$(Q)$(RM) -rf $(BUILD_DIR) $(OUTPUT_DIR) $(DEPDIR)

-include $(wildcard $(DEPFILES))

