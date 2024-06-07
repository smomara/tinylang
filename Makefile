# Variables to be set externally:
# MODE        - "debug" or "release" (default: release)

# Default values
MODE ?= release
NAME = tinylang

# Compiler settings
CC := gcc
CFLAGS += -Wall -Wextra -Werror -Wno-unused-parameter

# Exclude unused-function warnings if SNIPPET is defined
ifeq ($(SNIPPET),true)
	CFLAGS += -Wno-unused-function
endif

# Configuration based on build mode
ifeq ($(MODE),debug)
	CFLAGS += -O0 -DDEBUG -g
	BUILD_DIR := obj/debug
else
	CFLAGS += -O3 -flto
	BUILD_DIR := obj/release
endif

# Directory creation
MKDIR_P := mkdir -p

# Files and paths
HEADERS := $(wildcard src/*.h)
SOURCES := $(wildcard src/*.c)
OBJECTS := $(addprefix $(BUILD_DIR)/, $(notdir $(SOURCES:.c=.o)))

# Targets
.PHONY: all clean

all: $(NAME)

$(NAME): $(OBJECTS)
	@$(MKDIR_P) $(dir $@)
	@echo "Linking $@"
	$(CC) $(OBJECTS) -o $@ $(CFLAGS)

$(BUILD_DIR)/%.o: src/%.c $(HEADERS)
	@$(MKDIR_P) $(dir $@)
	@echo "Compiling $<"
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	rm -rf obj/