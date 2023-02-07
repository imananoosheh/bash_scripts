#!/bin/bash

# Get a list of all zombie processes
# $8 => 8th output of `ps aux` is STAT; if STAT is `Z`, the process is a zombie
# $2 => 2nd output of `ps aux` is the process id which is needed when killing.
zombies=($(ps aux | awk '{print $8 " " $2}' | grep -w Z))

# Loop through the list and kill each zombie process
for zombie in "${zombies[@]}"; do
  pid=$(echo "$zombie" | awk '{print $2}')
  kill -9 "$pid"
done
