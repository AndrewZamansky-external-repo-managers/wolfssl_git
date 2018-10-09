#ifndef WOLF_USER_SETTINGS_H
#define WOLF_USER_SETTINGS_H

#include "project_config.h"
#include "os_wrapper.h"

#ifdef CONFIG_CUSTOM_SOCKET_LAYER

	#define _strnicmp  strncasecmp

#if defined(FREERTOS)
	#define XREALLOC(p, n, h, t) os_safe_realloc((p), (n))
#endif

	#if defined(CONFIG_CORTEX_M4)
		#define SIZEOF_LONG 4
		#define SIZEOF_CURL_OFF_T 4
		#define SIZEOF_LONG_LONG  8
		#if defined(CONFIG_I94XXX)// defined in BSP nvttypes.h
			#undef FALSE
			#define FALSE 0
			#undef TRUE
			#define TRUE 1
		#endif
	#endif
	#include "sys/socket.h"

	#if defined(COMPILING_FOR_LINUX_HOST)
		#include <errno.h>
		#include <unistd.h>
		#define _strnicmp  strncasecmp
		#define _snprintf  snprintf
	#endif

	#define WSAEWOULDBLOCK  EAGAIN
	#define WSAEAGAIN  EAGAIN
	#define WSAECONNRESET ECONNRESET
	#define WSAEINTR  EINTR
	#define WSAECONNABORTED  ECONNABORTED
	#define WSAETIMEDOUT  ETIMEDOUT
#endif

#endif
