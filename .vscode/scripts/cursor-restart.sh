#!/bin/bash

bash "$(dirname "$0")/cursor-stop.sh"
sleep 2
bash "$(dirname "$0")/cursor-server.sh" 