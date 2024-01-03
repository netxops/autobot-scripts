#!/bin/bash

if [ -f /var/log/mcelog ]; then
    value=`grep -i error /var/log/mcelog  2>/dev/null`
    if [ -z "$value" ]; then
      MCELOG=正常
    else
      MCELOG=异常
    fi
else
  MCELOG=无
fi

echo $MCELOG