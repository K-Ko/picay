#!/bin/sh
###
### Simple Raspberry to Cayenne MQTT client
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###

#set -x

### Check for predefinded python to use
: ${PYTHON:=$(which python)}

data=

### Read defined metrics and build data to send
for file in ${0%/*}/metrics/*.sh; do
    data="$data $(. $file)"
done

### Send all to Cayenne
$PYTHON ${0%/*}/bin/cayenne-mqtt.py $data
