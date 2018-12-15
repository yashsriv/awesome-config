#!/usr/bin/env bash

var=$(ls -d -1 /home/yash/.bing-wallpapers/special/*.* | sort -R | head -n1)
echo -n "$var"
