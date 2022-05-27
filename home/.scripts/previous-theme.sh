#!/usr/bin/env bash
dwm_pid=$(pidof dwm)
exec xrdb -merge $HOME/.Xresources
kill -HUP $dwm_pid

