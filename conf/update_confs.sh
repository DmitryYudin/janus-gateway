set -e

export JANUS_DEBUG_LEVEL=4
export JANUS_WS_PORT=8090
export JANUS_ICE_LOCAL_IP=
export JANUS_ICE_PORT_RANGE=
export JANUS_TURN_REST_API=
export JANUS_TURN_SERVER=
export JANUS_TURN_PORT=3456
export JANUS_NOSIP_LOCAL_IP=
export JANUS_NOSIP_PORT_RANGE=
export JANUS_LS_HTTP_HOST=
export JANUS_LS_HTTP_PORT=
export JANUS_PROMETHEUS_HOST=0.0.0.0
export JANUS_PROMETHEUS_PORT=9091
mkdir -p $prefix/etc/janus
./config/set_config.sh

prefix=/usr/local
mkdir -p $prefix/share/janus/certs
install -c -m 644 certs/mycert.key certs/mycert.pem $prefix/share/janus/certs

prefix=/
mkdir -p $prefix/etc/asterisk
cp -f ./asterisk/extensions.conf $prefix/etc/asterisk/
cp -f ./asterisk/modules.conf $prefix/etc/asterisk/
cp -f ./asterisk/pjsip.conf  $prefix/etc/asterisk/
cp -f ./asterisk/rtp.conf $prefix/etc/asterisk/