#!/bin/bash

value=`dmesg |grep -i error`
if [ -z "$value" ]; then
  DMESG=正常
else
  DMESG=异常
fi

echo $DMESG