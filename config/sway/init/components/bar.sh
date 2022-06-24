#!/usr/bin/env bash

bar=$(pgrep waybar)
echo $bar

if [[ $bar ]]; then
  kill $bar
  waybar
else
  waybar
fi
