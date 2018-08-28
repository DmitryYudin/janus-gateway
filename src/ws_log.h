#ifndef __ws_log_h__
#define __ws_log_h__

#include <glib.h>

//
// Not a thread safe, assumeses get called from web-socket thread only
//
int ws_log_init(void);
#define WS_LOG_IN 0
#define WS_LOG_OUT 1
void ws_log_vprintf_text(int dir, const char *format, ...) G_GNUC_PRINTF(2, 3);
void ws_log_vprintf_json(int dir, const char *message);
void ws_log_destroy(void);

#endif
