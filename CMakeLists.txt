cmake_minimum_required(VERSION 3.12)
if (NOT CMAKE_BUILD_TYPE) 
  set(CMAKE_BUILD_TYPE Debug) 
endif() 

project(janus_clion)

set(CMAKE_CXX_STANDARD 14)
set(DIR_SRC ${PROJECT_SOURCE_DIR}/src)

include_directories(
        ${PROJECT_SOURCE_DIR}/src
)
include_directories(
        /usr/include/glib-2.0
        /usr/lib/x86_64-linux-gnu/glib-2.0/include)
include_directories(
        /usr/include/nice
        /usr/include/p11-kit-1
        /usr/include/gupnp-igd-1.0
        /usr/include/gupnp-1.0
        /usr/include/gssdp-1.0
        /usr/include/libsoup-2.4
        /usr/include/libxml2
        /usr/include/uuid)
#include_directories( ${INCLUDE_GLIB} ${INCLUDE_SYS} ${DIR_SRC})

set(DEFINES_JANUS
        PLUGINDIR="/usr/local/lib/janus/plugins"
        TRANSPORTDIR="/usr/local/lib/janus/transports"
        EVENTDIR="/usr/local/lib/janus/events"
        CONFDIR="/usr/local/etc/janus"
)

set(DEFINES_CONFIG
        PACKAGE_NAME="Janus\ Gateway"
        PACKAGE_TARNAME="janus-gateway"
        PACKAGE_VERSION="0.4.3"
        PACKAGE_STRING="Janus\ Gateway\ 0.4.3"
        PACKAGE_BUGREPORT="https://github.com/meetecho/janus-gateway"
        PACKAGE_URL="https://janus.conf.meetecho.com"
        PACKAGE="janus-gateway"
        VERSION="0.4.3"
        STDC_HEADERS=1
        HAVE_SYS_TYPES_H=1
        HAVE_SYS_STAT_H=1
        HAVE_STDLIB_H=1
        HAVE_STRING_H=1
        HAVE_MEMORY_H=1
        HAVE_STRINGS_H=1
        HAVE_INTTYPES_H=1
        HAVE_STDINT_H=1
        HAVE_UNISTD_H=1
        HAVE_DLFCN_H=1
        HAVE_PORTRANGE=1
        HAVE_LIBNICE_TCP=1
        HAVE_SRTP_2=1
        HAVE_LIBCURL=1
        HAVE_WEBSOCKETS=1
#        HAVE_LIBWEBSOCKETS_PEER_SIMPLE=1
        __EXTENSIONS__=1
        _ALL_SOURCE=1
        _GNU_SOURCE=1
        _POSIX_PTHREAD_SEMANTICS=1
        _TANDEM_SOURCE=1
        LT_OBJDIR=".libs/"
)
add_compile_definitions(${DEFINES_JANUS} ${DEFINES_CONFIG})

add_definitions(
        -Wall
        -Wstrict-prototypes
        -Wmissing-prototypes
        -Wmissing-declarations
        -Wunused
        -Wextra
        -Wformat=2
        -Winit-self
        -Winline
        -Wpacked
        -Wpointer-arith
        -Wmissing-format-attribute
        -Wmissing-noreturn
        -Wnested-externs
        -Wstrict-prototypes
        -Wwrite-strings
        -Wno-missing-field-initializers
        -Wno-unused-parameter
        -Wcast-align
        -Wformat-nonliteral
        -Wformat-security
        -Wswitch-default
        -Wmissing-include-dirs
        -Wno-aggregate-return
        -Warray-bounds
        -Wold-style-definition
        -Wsign-compare
        -Wno-undef
        -Wno-redundant-decls
)
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
	add_definitions(
		-Wno-cast-align
		-Wno-initializer-overrides
	)
elseif (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
	add_definitions(
        -Wunsafe-loop-optimizations
        -Wunused-but-set-variable
        -Wno-override-init
        -Wno-suggest-attribute=noreturn
	)
	set_source_files_properties(${DIR_SRC}/cmdline.c PROPERTIES COMPILE_FLAGS -Wno-unused-but-set-variable)
endif()

set(SRC_JANUS
        ${DIR_SRC}/apierror.c
        ${DIR_SRC}/auth.c
        ${DIR_SRC}/cmdline.c
        ${DIR_SRC}/config.c
        ${DIR_SRC}/dtls.c
        ${DIR_SRC}/dtls-bio.c
        ${DIR_SRC}/events.c
        ${DIR_SRC}/ice.c
        ${DIR_SRC}/log.c
        ${DIR_SRC}/record.c
        ${DIR_SRC}/rtcp.c
        ${DIR_SRC}/rtp.c
        ${DIR_SRC}/sctp.c
        ${DIR_SRC}/sdp.c
        ${DIR_SRC}/sdp-utils.c
        ${DIR_SRC}/ip-utils.c
        ${DIR_SRC}/turnrest.c
        ${DIR_SRC}/utils.c
        ${DIR_SRC}/version.c
        ${DIR_SRC}/text2pcap.c
        ${DIR_SRC}/plugins/plugin.c
        ${DIR_SRC}/plugins/janus_nosip.c
        ${DIR_SRC}/transports/transport.c
        ${DIR_SRC}/transports/janus_websockets.c
        ${DIR_SRC}/ws_log.c
)
set(ENABLE_ASAN 1)
#set(ENABLE_TSAN 1)

#set(CMAKE_VERBOSE_MAKEFILE on)
message(STATUS "========================================== CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE} CMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}")
if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_compile_definitions(DEBUG=1)
    add_compile_options(-O0)
elseif(CMAKE_BUILD_TYPE MATCHES Release)
    add_compile_definitions(DEBUG=0)
    add_compile_options(-O2)
endif()

# required for tsan
add_compile_options(-fPIE)
link_libraries(-pie)
add_compile_options(-fstrict-aliasing -fstack-protector-all -fno-omit-frame-pointer)

if(${ENABLE_ASAN})
	add_compile_options(-fsanitize=address)
	add_compile_options(-fsanitize=undefined -fsanitize=float-divide-by-zero)
	#add_compile_options(-fsanitize=memory -fsanitize-memory-track-origins)
	link_libraries(-fsanitize=address)
	if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
		link_libraries(-shared-libsan)
	elseif (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    	link_libraries(-lasan -lubsan)
	endif()
endif()
if(${ENABLE_TSAN})
	add_compile_options(-fsanitize=thread)
	link_libraries(-fsanitize=thread)
endif()

# static library
set(JANUS_LIB janus-static)
add_library(${JANUS_LIB} STATIC ${SRC_JANUS})

# executables
set(JANUS_EXE janus)
set(LIBS
	m dl gio-2.0 gobject-2.0 glib-2.0
	/usr/lib/x86_64-linux-gnu/libcurl.so
	config
	nice
	jansson
	ssl
	crypto
	srtp2
	websockets
)
add_executable(${JANUS_EXE} ${DIR_SRC}/janus.c)
target_link_libraries(${JANUS_EXE} ${JANUS_LIB} ${LIBS})



