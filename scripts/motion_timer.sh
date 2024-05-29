#!/bin/bash

last_run=0

while true; do
        current_time=$(date +%s)
        difference=$((current_time - last_run))
        if [ "$difference" -ge 3 ]; then
                last_run=$current_time
                /home/emli/scripts/motion_detect.sh 
        else
                sleep 1
        fi
done
