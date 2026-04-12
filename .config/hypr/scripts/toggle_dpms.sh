#!/bin/bash
STATE_FILE="/tmp/hypr_blackout"
if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
    hyprctl dispatch dpms on
else
    touch "$STATE_FILE"
    hyprctl dispatch dpms off
fi