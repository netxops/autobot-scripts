#!/bin/bash

value=`ps Haxwwo pid,command |egrep -i 'cups|sendmail|postfix|rpc|nfs' |grep -v grep |grep -v rpciod `
if [ -z "$value" ]; then
  NON_SECURE=正常
else
  NON_SECURE=$value
fi

echo $NON_SECURE