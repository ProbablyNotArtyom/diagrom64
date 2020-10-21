
CC := cc65		# C compiler
AS := ca65		# Assembler
LD := ld65		# Linker

## Directories ####################################################################################

BASEDIR	:= $(realpath .)
OBJDIR	:= $(BASEDIR)/bin/obj
BINDIR	:= $(BASEDIR)/bin
SRCDIR	:= $(BASEDIR)/src
LIBDIR	:= $(BASEDIR)/lib

ROMNAME		:= $(BINDIR)/diagrom.bin
CRTNAME		:= $(BINDIR)/diagrom.crt
BANKNAMES	:= $(BINDIR)/diagrom.hi $(BINDIR)/diagrom.lo

## Compiler flags #################################################################################

INCDIRS := $(BASEDIR)/include			# Create a list of directories to search for includes in
INCDIRS += /usr/share/cc65/asminc
INCDIRS += /usr/share/cc65/include

CFLAGS := -t c64 --cpu 6502 -g			# Generic platform flags
CFLAGS += $(addprefix -I, $(INCDIRS))	# Format the include directories

LDFLAGS := -C $(BASEDIR)/link.ld		# Set the linker config
LDFLAGS += -m $(BINDIR)/map				# Generate a mapfile
LDFLAGS += --dbgfile $(BINDIR)/debug	# Generate a debug listing
LDFLAGS += -Ln $(BINDIR)/vicesyms		# Generate VICE symbols

## Find sources ###################################################################################

SOURCES_ASM := $(shell find $(SRCDIR) -name '*.s')			# Find all assembly sources
SOURCES_C := $(shell find $(SRCDIR) -name '*.c')			# Find all C sources
OBJECTS_ASM := $(SOURCES_ASM:$(SRCDIR)/%.s=$(OBJDIR)/%.o)	# Create list of assembly objects
OBJECTS_C := $(SOURCES_C:$(SRCDIR)/%.c=$(OBJDIR)/%.o)		# Create list of C objects

## Functions ######################################################################################

# FUNCTION: rel,$1,$2
# returns the path of file $1 relative to directory $2
# if arg $2 is not passed, then the CWD is used instead
rel = $(shell realpath -m --relative-to=$(if $(2),$(2),$(realpath .)) $(1))

## Rules ##########################################################################################

.SILENT:
.NOTPARALLEL:
.SECONDEXPANSION:
.PHONY: all clean

#### Toplevel target ####
all: $(ROMNAME) $(BANKNAMES) $(CRTNAME)
	$(info [~~] Done)

#### Remove generated files ####
clean:
	rm -rf $(OBJDIR) $(ROMNAME) $(BINDIR)

#### Run cart with VICE ####
sim: $(ROMNAME)
	x64sc -cartultimax $^

#### Split ROM for use on real hardware ####
$(BANKNAMES) &: $(ROMNAME)
ifeq (,$(shell command -v split 2>/dev/null))		# Abort build if split isn't installed
	$(error [!] split utility not found. try installing GNU coreutils)
else
	$(info [..] Splitting ROM banks)
	split -b8k $^ -a1 -d $^.
	mv $^.0 $(word 2, $(BANKNAMES))
	mv $^.1 $(word 1, $(BANKNAMES))
endif

#### Create .crt image ####
$(CRTNAME) : $(ROMNAME)
ifeq (,$(shell command -v cartconv 2>/dev/null))	# Abort build if cartconv isn't installed
	$(error [!] cartconv utility not found. is the VICE emulator suite installed?)
else
	$(info [..] Creating .crt image)				# Notify cart creation
	cartconv -q -t ulti -i $^ -o $@					# Create a .crt image for use with emulators
endif

#### Build C sources ####
$(OBJECTS_C) : $$(patsubst $$(OBJDIR)%.o, $$(SRCDIR)%.c, $$@)
	mkdir -p $(dir $@)												# Make sure the generated object directory exists
	$(info [CC] -c $(call rel,$^) -o $(call rel,$(@:%.o=%.s)))		# Summarize CC invocation
	$(CC) $(CFLAGS) -O -Os $^ -o $(@:%.o=%.s)
	$(info [AS] $(call rel,$(@:%.o=%.s)) -o $(call rel,$@))			# Summarize AS invocation
	$(AS) -U $(CFLAGS) $(@:%.o=%.s) -o $@

#### Build assembly sources ####
$(OBJECTS_ASM) : $$(patsubst $$(OBJDIR)%.o, $$(SRCDIR)%.s, $$@)
	mkdir -p $(dir $@)												# Make sure the generated object directory exists
	$(info [AS] $(call rel,$^) -o $(call rel,$@))					# Summarize AS invocation
	$(AS) -U $(CFLAGS) $^ -o $@

#### Generate final linked binary ####
$(ROMNAME) : $(OBJECTS_C) $(OBJECTS_ASM)
	$(info [LD] $(call rel,$^,$(OBJDIR)) -o $(call rel,$@))			# Summarize LD invocation
	$(LD) $(LDFLAGS) $^ $(LIBDIR)/sys.lib -o $@
