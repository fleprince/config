#!/bin/bash -

line=`ifconfig | grep 192.168.`
local_addr=`echo $line | sed -e "s/.*inet addr:\(192.168.[0-9][0-9]*.[0-9][0-9]*\).*/\1/"`
drone_addr=`echo $local_addr | sed -e "s/\([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.\).*/\11/"`

echo "${drone_addr}"

