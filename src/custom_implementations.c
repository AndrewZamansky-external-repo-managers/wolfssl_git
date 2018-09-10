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
#endif
