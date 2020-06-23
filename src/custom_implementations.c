#include "project_config.h"
#include "_project.h"

#if defined(COMPILING_FOR_LINUX_HOST)
    /* Posix style time */
    #ifndef USER_TIME
    #include <time.h>
    #endif

    int32_t LowResTimer(void)
    {
        return (int32_t)time(0);
    }
#else
	int32_t LowResTimer(void)
	{
		return (int32_t)0;
	}
#endif

#include <sys/time.h>

int _gettimeofday( struct timeval *tv, void *tzvp )
{
    uint64_t t = 0;//__your_system_time_function_here__();  // get uptime in nanoseconds
    tv->tv_sec = t / 1000000000;  // convert to seconds
    tv->tv_usec = ( t % 1000000000 ) / 1000;  // get remaining microseconds
    return 0;  // return non-zero for error
} // end _gettimeofday()
