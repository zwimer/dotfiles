#!/bin/bash

mem=$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')
if [ $mem -le 2000000 ]; then
	echo ""
	echo "*** Insufficient memory. You need at least 2GB! ***"
	echo ""
	exit 1
fi
