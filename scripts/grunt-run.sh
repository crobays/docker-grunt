#!/bin/bash

if [ ! -f "/project/Gruntfile.js" ]
then
	gruntfile="./Gruntfile.js"
	cp -f /conf/Gruntfile.js $gruntfile
fi
source /usr/local/rvm/scripts/rvm

grunt
