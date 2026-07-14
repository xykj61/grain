TARGET = signed-kumara-verify
LIBS   = posix
SRC_C  = main.c monocypher.c monocypher-ed25519.c

# Teacher stays byte-pristine under vendor/monocypher — include path only.
MONOCYPHER_DIR := $(PRG_DIR)/../../../../../vendor/monocypher
INC_DIR += $(MONOCYPHER_DIR)/src $(MONOCYPHER_DIR)/src/optional $(PRG_DIR)

vpath main.c $(PRG_DIR)
vpath monocypher.c $(MONOCYPHER_DIR)/src
vpath monocypher-ed25519.c $(MONOCYPHER_DIR)/src/optional

CC_CXX_WARN_STRICT =
