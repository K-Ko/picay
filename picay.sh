#!/bin/sh
###
### Simple Raspberry to Cayenne MQTT client
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###

#set -x

### Core emperature
temp=$(awk '{printf "temperature,%f,c,temp", $1/1000}' /sys/class/thermal/thermal_zone0/temp)

### System load last 5 min.
load=$(awk '{printf "cpu,%f", $1}' /proc/loadavg)

### Real used memory
mem=$(free | awk '/-\/+/{printf "mem,%f", (1-$4/($3+$4))*100.0}')

### Used space on /
disk=$(df | awk '/\/$/{printf "disk,%f", $3/$2*100}')

### Running processes
process=$(awk '{gsub("[0-9]+/", ""); printf "process,%d", $4}' /proc/loadavg)

### Uptime in days
uptime=$(awk '{printf "uptime,%f", $1/60/60/24}' /proc/uptime)

### Send all to Cayenne
python $(dirname $0)/bin/cayenne-mqtt.py $temp $load $mem $disk $process $uptime
