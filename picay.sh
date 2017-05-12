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

pid="/tmp/picay.$(echo $@ | md5sum | cut -b-8).pid"

if ln -s "pid=$$" $pid 2>/dev/null; then
    trap "rm $pid" 0 1 2 3 15
else
    echo "Lock file $pid exists, exit"
    exit
fi

data=

### Read defined metrics and build data to send
for file in ${0%/*}/metrics/*.sh; do
    channel=$(basename $file | sed 's/\.sh//g')
    [ -f $(dirname $file)/$channel.disabled ] && continue
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

. ${0%/*}/picay.conf

### Send all to Cayenne
$PYTHON ${0%/*}/bin/cayenne-mqtt.py -u $USERNAME -p $PASSWORD -c $CLIENTID $data
