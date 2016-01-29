#!/bin/sh
# hack to restart transmission-daemon
sleep 2
killall -HUP transmission-daemon
