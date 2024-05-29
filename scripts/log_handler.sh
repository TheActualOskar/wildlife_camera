#!/bin/bash

echo $1 | systemd-cat -t ${2:-"of-log"} -p info
