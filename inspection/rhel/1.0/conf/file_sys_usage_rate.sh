#!/bin/bash

value=` df -TP / |egrep -v 'tmpfs|iso|docker|Filesystem|data' |awk -F'[ %]+' '{if($(NF-1)>=80) print}' |awk '{print $NF,$(NF-1)}'`
if [ -z "$value" ]; then
     DF=正常
else
     DF=$value
fi

echo $DF
