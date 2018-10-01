#!/bin/sh

if [[ "${1}" == 'sh' || "${1}" == '/bin/sh' ]];then
    /bin/sh
    exit 1
fi


work_path=${WORK_PATH:-/data}

if [ ! -d ${work_path} ]; then
  mkdir ${work_path}
fi

downloads=${work_path}/downloads
if [ ! -d ${downloads} ]; then
  mkdir ${downloads}
fi

session_file=${work_path}/aria2.session
if [ ! -f ${session_file} ]; then
  touch ${session_file}
fi

config_file=${work_path}/config.conf
if [ ! -f ${config_file} ]; then
  cat > ${config_file} <<__EOF
log=${work_path}/aria2.log
log-level=notice
console-log-level=notice

dir=${downloads}
continue=true

max-concurrent-downloads=10
max-connection-per-server=16
min-split-size=10M
split=16
max-overall-upload-limit=100K

input-file=${session_file}
save-session=${session_file}
save-session-interval=30

enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
event-poll=select
rpc-secret=${RPC_SECRET:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)}

listen-port=${LISTEN_PORT:-51413}
enable-dht=true
dht-file-path=${work_path}/dht.dat
dht-file-path6=${work_path}/dht6.dat
bt-enable-lpd=true
enable-peer-exchange=true
peer-id-prefix=-TR2770-
user-agent=Transmission/2.77
seed-ratio=0
bt-seed-unverified=true
bt-save-metadata=true
__EOF
fi

cat ${config_file}

aria2c --conf-path=${config_file}
