set -e

prefix=/usr/local
mkdir -p $prefix/etc/janus
cp -f ./janus/janus.jcfg $prefix/etc/janus/
cp -f ./janus/janus.plugin.nosip.jcfg  $prefix/etc/janus/
cp -f ./janus/janus.transport.websockets.jcfg  $prefix/etc/janus/
cp -f ./janus/janus.eventhandler.rabbitmqevh.jcfg $prefix/etc/janus/

prefix=/usr/local
mkdir -p $prefix/share/janus/certs
install -c -m 644 certs/mycert.key certs/mycert.pem $prefix/share/janus/certs

prefix=/
mkdir -p $prefix/etc/asterisk
cp -f ./asterisk/extensions.conf $prefix/etc/asterisk/
cp -f ./asterisk/modules.conf $prefix/etc/asterisk/
cp -f ./asterisk/pjsip.conf  $prefix/etc/asterisk/
cp -f ./asterisk/rtp.conf $prefix/etc/asterisk/