#!/bin/bash

# get root filesystem inode usage rate
value=$(df -iTP / | egrep -v 'tmpfs|iso|docker|Filesystem' | awk -F'[ %]+' '{if($(NF-1)>=70) print}' | awk '{print $NF,$(NF-1)}')
if [ -z "$value" ]; then
    FSINODE=正常
else
    FSINODE=$value
fi

echo $FSINODE