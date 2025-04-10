##
## toolchain
include $(MAKE_SYSTEM_DIR)/Makefile.toolchain
include $(MAKE_SYSTEM_DIR)/Makefile.Flags

#$(info find=$(FIND) $(LVGL_PATH))
ASRCS += $(shell $(FIND) $(LVGL_PATH)/src -type f -name *.S)
#$(info CSRCS=$(ASRCS))
CSRCS += $(shell $(FIND) $(LVGL_PATH)/src -type f -name *.c)
#$(info CSRCS=$(CSRCS))
CSRCS += $(shell $(FIND) $(LVGL_PATH)/demos -type f -name *.c)
#$(info CSRCS=$(CSRCS))
CSRCS += $(shell $(FIND) $(LVGL_PATH)/examples -type f -name *.c)
#$(info CSRCS=$(CSRCS))
CXXEXT := .cpp
CXXSRCS += $(shell $(FIND) $(LVGL_PATH)/src -type f -name "*$(CXXEXT)")
#$(info CXXSRCS=$(CXXSRCS))

LV_CONF_PATH=$(abspath lv_conf.h)
#$(info LV_CONF_PATH=$(LV_CONF_PATH))

AFLAGS += "-I$(LVGL_PATH)"
CFLAGS += "-I$(LVGL_PATH)"   -DLV_CONF_PATH="$(LV_CONF_PATH)" -DLV_USE_DEMO_WIDGETS
CPPFLAGS += "-I$(LVGL_PATH)" -DLV_CONF_PATH="$(LV_CONF_PATH)"
#$(info AFLAGS=$(AFLAGS))
#$(info CFLAGS=$(CFLAGS))
#$(info CPPFLAGS=$(CPPFLAGS))

DEPFILES  = $(addprefix $(DEPDIR)/, $(notdir $(CSRCS:%.c=$(DEPDIR)/%.d)), $(notdir $(CXXSRCS:%.cpp=$(DEPDIR)/%.d)))
DEPFLAGS  = -MT $@ -MMD -MP -MF $(DEPDIR)/$(notdir $*).d

LVGL_OBJ += $(addprefix $(BUILD_DIR)/, $(sort $(notdir $(ASRCS:%.S=$(BUILD_DIR)/%.o))))
#$(info LVGL_OBJ=$(LVGL_OBJ))
LVGL_OBJ += $(addprefix $(BUILD_DIR)/, $(sort $(notdir $(CSRCS:%.c=$(BUILD_DIR)/%.o))))
#$(info LVGL_OBJ=$(LVGL_OBJ))
LVGL_OBJ += $(addprefix $(BUILD_DIR)/, $(sort $(notdir $(CXXSRCS:%.cpp=$(BUILD_DIR)/%.o))))
#$(info LVGL_OBJ=$(LVGL_OBJ))
SEARCH_SRCDIRS=$(sort $(dir $(CSRCS) $(CXXSRCS) $(ASRCS)) .)
VPATH += $(SEARCH_SRCDIRS)
#$(info VPATH=$(VPATH))
#$(info LVGL_OBJ=$(LVGL_OBJ))

INCLUDES = $(patsubst %,-I%, $(sort $(SEARCH_SRCDIRS) \
               $(wildcard $(shell $(FIND) $(LVGL_PATH) -type f -name "*.h")) \
             )))

#$(info INCLUDES=$(INCLUDES))

include $(MAKE_SYSTEM_DIR)/Makefile.rules

lvgl:  $(LVGL_DEPDIR) $(OUTPUT_DIR) $(BUILD_DIR) $(OUTPUT_DIR)/lib$(DEVICE).lvgl.a $(OUTPUT_DIR)/lib$(DEVICE).lvgl.list

$(OUTPUT_DIR)/lib$(DEVICE).lvgl.a: $(LVGL_OBJ)
	$(Q)$(MKDIR) -p $(dir $@)
	$(Q)$(PRINTF) "  [AR]  $(notdir $@)\n"
	$(Q)cd $(BUILD_DIR) && $(AR) $(ARFLAGS) "$@" *.o
	
$(LVGL_DEPDIR) $(OUTPUT_DIR) $(BUILD_DIR): 
	$(Q)$(PRINTF) "  [MKDIR]  $@\n"
	$(Q)$(MKDIR) -p $@

$(DEPFILES): $(LVGL_DEPDIR)

clean:
	$(Q)$(PRINTF) "  [CLEAN]\t$@\n"
	$(Q)$(RM) -rf $(BUILD_DIR) $(OUTPUT_DIR)
	