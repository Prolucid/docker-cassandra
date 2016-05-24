#!/bin/bash

# Setup data directory and permissions
mkdir -p /var/lib/cassandra
chown cassandra:cassandra /var/lib/cassandra

exec setuser cassandra cassandra -f 
