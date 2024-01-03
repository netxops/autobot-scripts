#!/bin/bash

# get /var/spool dir size (MB)
value=`du -sm /var/spool |awk '{if($1>=10240) print $1}'`
if [ -z "$value" ]; then
     SPOOLDIR=正常
else
     SPOOLDIR=$value
fi

echo $SPOOLDIR