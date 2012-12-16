#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: wait_until HH:MM"
    exit
fi

DESIRED=$((`date +%s -d "$1"`))
NOW=$((`date +%s`))
SECONDS=$((DESIRED-NOW))

if [ $# -eq 1 ]; then
    sleep $SECONDS && zenity --info
    exit
fi

if [ $# -eq 2 ]; then
    sleep $SECONDS && zenity --info --text $2
    exit
fi
