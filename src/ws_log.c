#include "ws_log.h"
#include "utils.h"

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <jansson.h>

char global_log_prefix[64];
static FILE *log_file = NULL;

int ws_log_init(void)
{
    char logpath[256]; // or whatever, I think there is a #define for this, something like PATH_MAX
    sprintf(logpath, "%s/%s_ws.log", getenv("HOME"), global_log_prefix);

    log_file = fopen(logpath, "awt");
    if(log_file == NULL) {
        g_print("Error opening log file %s: %s\n", logpath, strerror(errno));
        return -1;
    }
    return 0;
}

static char* g_buf = NULL;
static size_t g_buf_allocated = 0;
void ws_log_vprintf_text(int dir, const char *format, ...)
{
    if(!log_file) {
        return;
    }
    int len;
    va_list ap, ap2;

    va_start(ap, format);
    va_copy(ap2, ap);
    /* first try */
    len = vsnprintf(g_buf, g_buf_allocated, format, ap);
    va_end(ap);
    if (len >= (int) g_buf_allocated) {
        /* buffer wasn't big enough */
        g_buf = g_realloc(g_buf, len + 1024);
        g_buf_allocated = len + 1024;
        vsnprintf(g_buf, g_buf_allocated, format, ap2);
    }
    va_end(ap2);

    const char *pref = dir == WS_LOG_IN ?
                       "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n" :
                       ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n" ;
    char date[64];
    janus_date_str(date, sizeof(date), "%H-%M-%S ");
    fputs(date, log_file);
    fputs(pref, log_file);
    fputs(g_buf, log_file);
    fputs("\n", log_file);
    fflush(log_file);
}

void ws_log_vprintf_json(int dir, const char *message)
{
    json_error_t error;
    json_t *root = json_loads(message, 0, &error);
    if(!root) {
        g_print("Error reading json message: %s\n", message);
        return;
    }
    char* data = json_dumps(root, JSON_INDENT(2)|JSON_PRESERVE_ORDER);
    json_decref(root);

#if 0
    char* p = data;
    while(*p != '\0') {
        if(0 == strncmp("\\r\\n", p, 4)) {
            p[0] = ' ';
            p[1] = ' ';
            p[2] = ' ';
            p[3] = '\n';
        } else {
            p++;
        }
    }
#endif
    ws_log_vprintf_text(dir, "%s", data);

    free(data);
}

void ws_log_destroy(void)
{
    if(log_file) {
        fclose(log_file);
    }
    log_file = NULL;
    if(g_buf) {
        g_free(g_buf);
    }
}
