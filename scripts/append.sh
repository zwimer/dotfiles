#!/bin/bash -eux

# Args
MODE="$1"
DATA="$2"
ADD_TO="$3"
PREFIX="${4-#}"

function prefix() {
	if [[ -f "$ADD_TO" ]]; then
		echo $'\n'"${PREFIX} -------------------- Appended --------------------"$'\n' >>"$ADD_TO"
	fi
}

if [[ "$MODE" == "str" ]]; then
	prefix
	echo "$DATA" >>"$ADD_TO"
elif [[ "$MODE" == "file" ]]; then
	prefix
	cat "$DATA" >>"$ADD_TO"
else
	>&2 echo "Unsupported mode $MODE"
	exit 1
fi
