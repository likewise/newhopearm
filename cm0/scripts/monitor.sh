#!/bin/sh
DEVICE=/dev/ttyUSB0

stty -F $DEVICE raw icanon eof \^d 9600
$1 write $2 0x8000000 >/dev/null 2>&1
cat < $DEVICE
