#!/bin/bash -eux

MEM="$(cat /proc/meminfo | grep MemTotal | awk '{ print $2 }')"
if [[ "${MEM}" -le 2000000 ]]; then
	echo ""
	echo "*** Insufficient memory. You need at least 2GB! ***"
	echo ""
	exit 1
fi

if ! grep "\" Plugin 'Valloric/YouCompleteMe'" ~/.vimrc >/dev/null 2>/dev/null; then
	echo ""
	echo "*** Please add the following line to your .vimrc in the plugin section ***"
	echo "\" Plugin 'Valloric/YouCompleteMe'"
	echo ""
	exit 1
fi
