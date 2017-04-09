OPENCM3LIB=libopencm3
OPENCM3LIB_DIR=./${OPENCM3LIB}

OPENDPS=opendps
OPENDPS_DIR=./${OPENDPS}

BUILD_ESPPROXY=YES

SUBDIRS=${OPENCM3LIB_DIR} ${OPENDPS_DIR}

ARM_CC=arm-none-eabi-gcc
ARM_CC_PRESENT=$(shell which ${ARM_CC})

ifeq ($(strip ${ARM_CC_PRESENT}),)
COMPILER_CHECK=check_compiler
endif

BUILD_ESPPROXY=YES

ifeq ($(strip ${BUILD_ESPPROXY}),YES)
ESPPROXY=esp8266-proxy
ESPPROXY_DIR=./${ESPPROXY}

# the ESP RTOS root dir. The EOR_ROOT variable is required and used
# by the proxy build system.
EOR=esp-open-rtos
export EOR_ROOT=$(shell pwd)/../${EOR}
EOR_SCM_REPOSITORY=https://github.com/kanflo/${ESP_RTOS_SDK}.git

SUBDIRS+=${ESPPROXY_DIR}
endif

.PHONY: subdirs ${COMPILER_CHECK} ${SUBDIRS}

all:	${COMPILER_CHECK} subdirs

subdirs:	${SUBDIRS}

check_compiler:
	$(error "${ARM_CC} is not in your PATH!")

${SUBDIRS}:
	${MAKE} -${MAKEFLAGS} -C $@


${OPENDPS_DIR}:	${OPENCM3LIB_DIR}

${ESP_PROXY_DIR}:	${EOR_ROOT}

${EOR_ROOT}:
	git clone $< $@  	\
	cd $@			\
	git submodule init	\
	git submodule update	\
	git checkout -b netif remotes/origin/sdk_system_get_netif
