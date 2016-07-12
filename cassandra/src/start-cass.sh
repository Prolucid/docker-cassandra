#!/bin/bash

# Setup data directory and permissions
mkdir -p /var/lib/cassandra
chown cassandra:cassandra /var/lib/cassandra

CONFIG=/etc/cassandra

IP=$(hostname --ip-address)
sed -i -e "s,^listen_address.*,listen_address: $IP,g" $CONFIG/cassandra.yaml
sed -i -e "s,^rpc_address.*,rpc_address: $IP,g" $CONFIG/cassandra.yaml
sed -i -e "s,# broadcast_address.*,broadcast_address: $IP,g" $CONFIG/cassandra.yaml
sed -i -e "s,# broadcast_rpc_address.*,broadcast_rpc_address: $IP,g" $CONFIG/cassandra.yaml
sed -i -e "s,- seeds: \"127.0.0.1\",- seeds: \"$SEEDS\",g" $CONFIG/cassandra.yaml

sed -i -e "s,authenticator: AllowAllAuthenticator,authenticator: PasswordAuthenticator,g" $CONFIG/cassandra.yaml
sed -i -e "s,authorizer: AllowAllAuthorizer,authorizer: CassandraAuthorizer,g" $CONFIG/cassandra.yaml

exec setuser cassandra cassandra -f 
