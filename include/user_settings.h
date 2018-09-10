#ifndef WOLF_USER_SETTINGS_H
#define WOLF_USER_SETTINGS_H

#include "project_config.h"

#ifdef CONFIG_CUSTOM_SOCKET_LAYER

	#include "sys/socket.h"

	#if defined(COMPILING_FOR_LINUX_HOST)
		#include <errno.h>
		#include <unistd.h>
		#define _strnicmp  strncasecmp
	#endif

	#define WSAEWOULDBLOCK  EAGAIN
	#define WSAEAGAIN  EAGAIN
	#define WSAECONNRESET ECONNRESET
	#define WSAEINTR  EINTR
	#define WSAECONNABORTED  ECONNABORTED
	#define WSAETIMEDOUT  ETIMEDOUT
#endif

#endif
