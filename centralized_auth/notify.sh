#!/bin/bash

REMOTE="postgres@172.20.0.4"
FILE="/var/lib/postgresql/ip.txt"
CLUE="ok"

while true;do
	if ssh "$REMOTE" "grep -q '$CLUE' '$FILE'"; then
		choice=$(echo -e "yes\nno" | dmenu -p "Clue '$CLUE' found. proceed?")
		if [ "$choice" = "yes" ]; then
			echo "selected yes"
			ssh "$REMOTE" "echo '' > '$FILE'"
			exit 0
		else 
			echo "selected no"
		fi
		sleep 5
	fi
	sleep 2
done
