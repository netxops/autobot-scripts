#!/bin/bash

# get /var/log dir size (MB)
value=`du -sm /var/log |awk '{if($1>=10240) print $1}'`
if [ -z "$value" ]; then
     LOGDIR=正常
else
     LOGDIR=$value
fi

echo $LOGDIR