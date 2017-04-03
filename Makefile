OPENCM3LIB=libopencm3
OPENCM3LIB_DIR=./${OPENCM3LIB}

OPENDPS=opendps
OPENDPS_DIR=./${OPENDPS}

SUBDIRS=${OPENCM3LIB_DIR} ${OPENDPS_DIR}

ARM_CC=arm-none-eabi-gcc
ARM_CC_PRESENT=$(shell which ${ARM_CC})

ifeq ($(strip ${ARM_CC_PRESENT}),)
COMPILER_CHECK=check_compiler
endif

.PHONY: subdirs ${COMPILER_CHECK} ${SUBDIRS}

all:	${COMPILER_CHECK} subdirs

subdirs:	${SUBDIRS}

check_compiler:
	$(error "${ARM_CC} is not in your PATH!")

${SUBDIRS}:
	${MAKE} -${MAKEFLAGS} -C $@

${OPENDPS_DIR}:	${OPENCM3LIB_DIR}
