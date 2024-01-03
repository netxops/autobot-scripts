#!/bin/bash

value=`ip link |grep bond |grep -v veth |grep 'state DOWN' |awk -F':' '{print $2}'`
if [ -z "$value" ]; then
  NETDEVICE=正常
else
  NETDEVICE=$value
fi

echo $NETDEVICE