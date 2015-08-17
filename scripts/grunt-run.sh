#!/bin/bash
cd /project
gruntfile="./Gruntfile.js"
if [ ! -f "$gruntfile" ]
then
	cp -f /conf/Gruntfile.js "$gruntfile"
fi
source /usr/local/rvm/scripts/rvm

grunt
