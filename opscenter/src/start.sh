#!/usr/bin/env bash
set -x

if [ -n ${!CASSANDRA_SEEDS} ]
  then
   echo ${!CASSANDRA_SEEDS}
   CASSANDRA_SEEDS=${!CASSANDRA_SEEDS}
fi

IP=`hostname --ip-address`

sed -i -e "s/^interface.*/interface = $IP/" /etc/opscenter/opscenterd.conf
# sed -i -e "s/^seed_hosts.*/seed_hosts = $CASSANDRA_SEEDS/" /etc/opscenter/opscenterd.conf

echo Starting OpsCenter on $IP...
supervisord -n -c /etc/supervisor/supervisord.conf
