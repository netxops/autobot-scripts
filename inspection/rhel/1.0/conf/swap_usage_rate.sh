#!/bin/bash

value=`free |grep -i swap: |awk '{if(($3*2)>$2) print $3}'`
if [ -z "$value" ]; then
  SWAP=正常
else
  SWAP=异常
fi

echo $SWAP