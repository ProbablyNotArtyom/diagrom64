
BASEDIR := $(PWD)
OBJDIR := $(BASEDIR)/obj
BINDIR := $(BASEDIR)/bin
SRCDIR := $(BASEDIR)/src
INCDIR := $(BASEDIR)/include

SOURCES_ASM := $(shell find $(SRCDIR) -name '*.s')
OBJECTS_ASM := $(patsubst $(SRCDIR)/%.s, $(OBJDIR)/%.o, $(SOURCES_ASM))
SOURCES := $(shell find $(SRCDIR) -name '*.c')
OBJECTS := $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SOURCES))

FILNAME := diagrom

CC      = cc65
AS		= ca65
LD		= ld65
CFLAGS  = -t c64 --cpu 6502 -I $(INCDIR) --debug-info -g
LDFLAGS = -Ln $(BINDIR)/$(FILNAME).vice --dbgfile $(BINDIR)/$(FILNAME).dbg -m $(BINDIR)/$(FILNAME).map -C $(BASEDIR)/link.ld

########################################

.PHONY: all clean sim
all: $(FILNAME)

clean:
	rm -rf $(OBJDIR)/*
	rm -rf $(BINDIR)/*
	rm -f $(FILNAME)

sim: $(FILNAME)
	x64sc -cartultimax $(BINDIR)/$(FILNAME)

.SECONDEXPANSION:
$(OBJECTS): $$(patsubst $$(OBJDIR)%.o, $$(SRCDIR)%.c, $$@)
	@echo "[CC] -c $(shell realpath -m --relative-to=$(PWD) $(patsubst $(OBJDIR)%, $(SRCDIR)%, $(@:%.o=%.c))) -o $(shell realpath -m --relative-to=$(PWD) $(@:%.o=%.s))"
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -O -Os $(patsubst $(OBJDIR)%, $(SRCDIR)%, $(@:%.o=%.c)) -o $(@:%.o=%.s)
	@$(AS) -U $(CFLAGS) $(@:%.o=%.s) -o $(shell realpath -m --relative-to=$(PWD) $(@))

$(OBJECTS_ASM): $$(patsubst $$(OBJDIR)%.o, $$(SRCDIR)%.s, $$@)
	@echo "[AS] $(shell realpath -m --relative-to=$(PWD) $(patsubst $(OBJDIR)%, $(SRCDIR)%, $(@:%.o=%.s))) -o $(shell realpath -m --relative-to=$(PWD) $(@))"
	@mkdir -p $(dir $@)
	@$(AS) -U $(CFLAGS) $(patsubst $(OBJDIR)%, $(SRCDIR)%, $(@:%.o=%.s)) -o $(shell realpath -m --relative-to=$(PWD) $(@))

$(FILNAME): $(OBJECTS) $(OBJECTS_ASM)
	@echo "[LD] Creating final binary"
	@$(LD) $(LDFLAGS) $(shell find $(OBJDIR) -name '*.o') $(INCDIR)/cool.lib -o $(BINDIR)/$@
	@split -b8k $(BINDIR)/$(FILNAME) -a1 -d $(BINDIR)/$(FILNAME).
	@rm -f $(BINDIR)/$(FILNAME).0
	@mv $(BINDIR)/$(FILNAME).1 $(BINDIR)/romhi
