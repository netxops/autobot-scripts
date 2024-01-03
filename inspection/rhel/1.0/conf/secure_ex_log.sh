#!/bin/bash

value=`grep -i fail /var/log/secure  2>/dev/null`
if [ -z "$value" ]; then
  SECURE=正常
else
  SECURE=异常
fi

echo $SECURE