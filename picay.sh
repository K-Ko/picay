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

conf=${0%/*}/picay.conf

[ ! -s $conf ] && echo "Missing configuration file $conf" && exit

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

BBlue='\033[1;34m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
ColorOff='\033[0m'

### Defaults
HOST=mqtt.mydevices.com
PORT=1883
VERBOSE=

. $conf

[ "$VERBOSE" ] && d=-d

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

    topic=v1/$USERNAME/things/$CLIENTID/data/$channel
    data="$(. $file)"

    printf "${BBlue}%s/%s${ColorOff}\n%s ..." $topic $channel $data
    [ "$d" ] && printf "\n"

    mosquitto_pub $d -i $CLIENTID -h $HOST -p $PORT -u $USERNAME -P $PASSWORD -t $topic -m "$data" -q 1
    rc=$?

    [ "$d" ] || s="\x8\x8\x8- "

    if [ $rc -eq 0 ]; then
        printf "$s${BGreen}ok${ColorOff}\n"
    else
        printf "$sERROR ${BRed}%d{ColorOff}\n" $rc
    fi

done
