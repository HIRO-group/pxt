#!/bin/bash

# Start the first process
roslaunch rosbridge_server rosbridge_websocket.launch &
  
# Start the second process
cd /home/ros/makecode/pxt-microbit && pxt serve -h 0.0.0.0 --rebundle
  
# # Wait for any process to exit
# wait -n
  
# # Exit with status of process that exited first
# exit $?

