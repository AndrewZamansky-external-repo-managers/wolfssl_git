
INCLUDE_THIS_COMPONENT := $(CONFIG_INCLUDE_WOLFSSL)

ifeq ($(strip $(CONFIG_INCLUDE_WOLFSSL)),y)

    EXPANDED_MAKEFILE_LIST := $(realpath $(MAKEFILE_LIST))
    CURR_FILE_SUFFIX :=wolfssl_git/Makefile.uc.mk
    CURR_MAKEFILE :=$(filter %$(CURR_FILE_SUFFIX), $(EXPANDED_MAKEFILE_LIST))
    CURR_COMPONENT_DIR := $(patsubst %/Makefile.uc.mk,%,$(CURR_MAKEFILE))

    #test if current commit and branch of nghttp2 git is
    # the same as required by application
    CURR_GIT_REPO_DIR :=$(CURR_COMPONENT_DIR)
    CURR_GIT_COMMIT_HASH_VARIABLE :=CONFIG_WOLFSSL_GIT_MANAGER_COMMIT_HASH
    include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk

    WOLFSSL_GIT_COMMIT_HASH :="1179969dcf81e1e44fd35e387febd4f8ca38d85d"

    WOLFSSL_PATH :=$(EXTERNAL_SOURCE_ROOT_DIR)/wolfssl
    ifeq ("$(wildcard $(WOLFSSL_PATH))","")
        $(info   )
        $(info --- wolfSSL path $(WOLFSSL_PATH) dont exists )
        $(info --- get repo from andew zamansky or from https://github.com/wolfSSL/wolfssl)
        $(info --- make sure that .git directory is located in $(WOLFSSL_PATH)/  after unpacking)
        $(error )
    endif

	# test if current commit and branch of wolfssl git is the same as required by application
	CURR_GIT_REPO_DIR :=$(WOLFSSL_PATH)
	CURR_GIT_COMMIT_HASH_VARIABLE :=WOLFSSL_GIT_COMMIT_HASH
	CURR_GIT_BUNDLE :=$(CURR_COMPONENT_DIR)/wolfssl.bundle
	include $(MAKEFILES_ROOT_DIR)/_include_functions/git_prebuild_repo_check.mk

    DUMMY := $(call ADD_TO_GLOBAL_INCLUDE_PATH , $(WOLFSSL_PATH))

    ifeq ($(CONFIG_HOST),y)
        DEFINES += COMPILING_FOR_HOST
        ifeq ($(findstring WINDOWS,$(COMPILER_HOST_OS)),WINDOWS)
            ifdef CONFIG_MICROSOFT_COMPILER
                # disable warning C4127: conditional expression is constant
                CFLAGS += /wd4127
                # disable warning C4204: nonstandard
                # extension used : non-constant aggregate initializer
                CFLAGS += /wd4204
                # disable warning C4214: nonstandard 
                # extension used : bit field types other than int
                CFLAGS += /wd4214
                DEFINES += _CRT_SECURE_NO_WARNINGS
            endif
            DEFINES += COMPILING_FOR_WINDOWS_HOST
        else
            DEFINES += COMPILING_FOR_LINUX_HOST
        endif
    endif


    DEFINES += NO_DSA  NO_MD4 NO_PSK  WC_NO_RSA_OAEP NO_WOLFSSL_SERVER
    DEFINES += NO_ERROR_STRINGS NO_RC4 NO_RABBIT
    DEFINES += NO_HC128  SMALL_SESSION_CACHE  WOLFSSL_SMALL_STACK


    DEFINES += WOLFSSL_STATIC_RSA
    DEFINES += NO_DES3 NO_WRITEV

    SRC += src/ssl.c

    ifeq ($(strip $(CONFIG_WOLFSSL_HAVE_ALPN)),y)
        DEFINES += HAVE_ALPN
    endif

    ifeq ($(strip $(CONFIG_WOLFSSL_USE_CUSTOM_RANDOM_GENERATOR)),y)
        DEFINES += CUSTOM_RAND_GENERATE=custom_rand_generate
    endif

    ifneq ($(strip $(CONFIG_WOLFSSL_MD5)),y)
        DEFINES += WOLFSSL_NO_MD5
    endif

    ifneq ($(strip $(CONFIG_WOLFSSL_DONT_USE_FILESYSTEM)),y)
        DEFINES += NO_FILESYSTEM
    endif

    ifneq ($(strip $(CONFIG_WOLFSSL_TLS)),y)
        DEFINES += NO_TLS
    else
        SRC += src/tls.c
    endif

    ifneq ($(strip $(CONFIG_WOLFSSL_RSA)),y)
        DEFINES += NO_RSA
    else
        SRC += wolfcrypt/src/rsa.c
    endif


    ifeq ($(strip $(CONFIG_WOLFSSL_ECC)),y)
        DEFINES += HAVE_ECC
        SRC += wolfcrypt/src/ecc.c
    endif

    ifeq ($(strip $(CONFIG_WOLFSSL_AES)),y)
        SRC += wolfcrypt/src/aes.c
    endif

    ifeq ($(strip $(CONFIG_WOLFSSL_DHE_RSA_WITH_AES_128_GCM_SHA256)),y)
        DEFINES += HAVE_AESGCM
    endif
    ifeq ($(strip $(CONFIG_WOLFSSL_ECDHE_RSA_WITH_AES_128_GCM_SHA256)),y)
        DEFINES += HAVE_AESGCM
    endif
    ifeq ($(strip $(CONFIG_WOLFSSL_ECDHE_RSA_WITH_AES_256_GCM_SHA384)),y)
        DEFINES += HAVE_AESGCM
    endif


    ifeq ($(strip $(CONFIG_WOLFSSL_TLS_EXTENSIONS)),y)
        DEFINES += HAVE_TLS_EXTENSIONS
    endif



    ifneq ($(strip $(CONFIG_WOLFSSL_MD5)),y)
        DEFINES += NO_MD5
    else
        SRC += wolfcrypt/src/md5.c
    endif

    ifeq ($(strip $(CONFIG_WOLFSSL_SHA384)),y)
        DEFINES += WOLFSSL_SHA384
    endif

    ifeq ($(strip $(CONFIG_WOLFSSL_SHA512)),y)
        SRC += wolfcrypt/src/sha512.c
        DEFINES += WOLFSSL_SHA512
    endif

    ifeq ($(strip $(CONFIG_WOLFSSL_SHA256)),y)
        SRC += wolfcrypt/src/sha256.c
    else
        DEFINES += NO_SHA256
    endif

    ifneq ($(strip $(CONFIG_WOLFSSL_DH)),y)
        DEFINES += NO_DH
    else
        DEFINES += HAVE_DH
        SRC += wolfcrypt/src/dh.c
    endif

    ifneq ($(strip $(CONFIG_WOLFSSL_HMAC)),y)
        DEFINES += NO_HMAC
    else
        SRC += wolfcrypt/src/hmac.c
    endif



    SRC += src/internal.c
    SRC += src/keys.c

    SRC += wolfcrypt/src/random.c
    SRC += wolfcrypt/src/memory.c
    SRC += wolfcrypt/src/wc_port.c
    SRC += wolfcrypt/src/asn.c
    SRC += wolfcrypt/src/wc_encrypt.c
    SRC += wolfcrypt/src/integer.c
    SRC += src/wolfio.c
    SRC += wolfcrypt/src/sha.c
    SRC += wolfcrypt/src/hash.c
    SRC += wolfcrypt/src/coding.c
    SRC += wolfcrypt/src/pwdbased.c
    SRC += wolfcrypt/src/wolfmath.c

    SPEED_CRITICAL_FILES += $(SRC)
    VPATH += | $(WOLFSSL_PATH)

    DISABLE_GLOBAL_INCLUDES_PATH := y

endif # CONFIG_INCLUDE_WOLFSSL = y

include $(COMMON_CC)
