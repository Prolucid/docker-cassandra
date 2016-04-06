#!/bin/bash

# Accept listen_address
IP=${LISTEN_ADDRESS:-`hostname --ip-address`}
# Cassandr aConfig location
CONFIG=/etc/cassandra

# Setup Cassandra params
sed -i -e "s/^listen_address.*/listen_address: $IP/"            $CONFIG/cassandra.yaml
sed -i -e "s/^rpc_address.*/rpc_address: $IP/"              $CONFIG/cassandra.yaml
sed -i -e "s/# broadcast_address.*/broadcast_address: $IP/"              $CONFIG/cassandra.yaml
sed -i -e "s/# broadcast_rpc_address.*/broadcast_rpc_address: $IP/"              $CONFIG/cassandra.yaml
sed -i -e "s/# native_transport_max_threads.*/native_transport_max_threads: 1024/"              $CONFIG/cassandra.yaml
sed -i -e "s/^commitlog_segment_size_in_mb.*/commitlog_segment_size_in_mb: 64/"              $CONFIG/cassandra.yaml
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$SEEDS\"/"       $CONFIG/cassandra.yaml
sed -i -e "s/incremental_backups: false/incremental_backups: $ENABLE_INCREMENTAL_BACKUPS/g"       $CONFIG/cassandra.yaml
sed -i -e "s/# JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=<public name>\"/ JVM_OPTS=\"$JVM_OPTS -Djava.rmi.server.hostname=$IP\"/" $CONFIG/cassandra-env.sh
#sed -i -e "s/# initial_token:.*/initial_token: $INITIAL_TOKEN/"       $CONFIG/cassandra.yaml
sed -i -e "s/num_tokens.*/num_tokens: 256/"           $CONFIG/cassandra.yaml
sed -i -e "s/^\(\\s*\)<appender-ref ref=\"ASYNCDEBUGLOG\" \/>/\\1<\!--<appender-ref ref=\"ASYNCDEBUGLOG\" \/>-->/" $CONFIG/logback.xml

# SETUP CASSANDRA PORTS

sed -i -e "s/^storage_port.*/storage_port: $INTERNODE_PORT/"            $CONFIG/cassandra.yaml
sed -i -e "s/^rpc_port.*/rpc_port: $THRIFT_PORT/"            $CONFIG/cassandra.yaml
sed -i -e "s/^native_transport_port.*/native_transport_port: $NATIVE_TRANSPORT_PORT/"            $CONFIG/cassandra.yaml
sed -i -e "s/^JMX_PORT=\"7199\"/JMX_PORT=\"$JMXPORT\"/"            $CONFIG/cassandra-env.sh

if [[ $SNITCH ]]; then
  sed -i -e "s/endpoint_snitch: SimpleSnitch/endpoint_snitch: $SNITCH/" $CONFIG/cassandra.yaml
fi
if [[ $DC && $RACK ]]; then
  echo "dc=$DC" > $CONFIG/cassandra-rackdc.properties
  echo "rack=$RACK" >> $CONFIG/cassandra-rackdc.properties
fi

exec cassandra -f 
