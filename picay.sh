#!/usr/bin/env bash
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

if [ "$1" ]; then
    ### If there is a parameter starting with '-',
    ### exclude channels otherwise only send defined channels
    [ "${1:0:1}" != - ] && include="$1," || exclude="${1:1},"
fi

data=

### Read defined metrics and build data to send
for file in ${0%/*}/metrics/*.sh; do
    channel=$(basename $file | sed 's/\.sh//g')

    if [ "$include" ]; then
        echo $include | grep -q "$channel,"
        [ $? -eq 0 ] || continue
    elif [ "$exclude" ]; then
        echo $exclude | grep -q "$channel,"
        [ $? -eq 0 ] && continue
    fi

    data="$data $channel,$(. $file)"
done

echo $data
echo

### Send all to Cayenne
$PYTHON ${0%/*}/bin/cayenne-mqtt.py $data
