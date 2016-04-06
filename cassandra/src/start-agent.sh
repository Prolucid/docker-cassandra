#!/bin/bash

# Configure Datstax agent
sed -i -e "s/%OPSCENTER_HOST%/$OPSCENTER_HOST/" /etc/datastax-agent/address.yaml

exec /usr/share/datastax-agent/bin/datastax-agent -f
