#!/bin/bash

if [ -f /etc/lsb-release ]; then
  # travis issue :(
  sudo locale-gen en_US.UTF-8
fi

sudo su -c /avm/test/integration/simple/install.sh kitchen
