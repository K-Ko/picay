#!/usr/bin/env bash
###
### Simple Raspberry to Cayenne MQTT client
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###

HOST=mqtt.mydevices.com
PORT=1883

### --------------------------------------------------------------------------

conf=${0%/*}/picay.conf

[ ! -s $conf ] && echo "Missing configuration file $conf" && exit

if [ "$1" ]; then
    ### If there is a parameter starting with '-',
    ### exclude channels otherwise only send defined channels
    [ "${1:0:1}" != - ] && include="$1," || exclude="${1:1},"
fi

pid="/tmp/picay.$(echo $@ | md5sum | cut -b-8).pid"

if ln -s "pid=$$" $pid 2>/dev/null; then
    tmp=$(mktemp)
    trap "rm $pid $tmp" 0 1 2 3 15
else
    echo "Lock file $pid exists, exit"
    exit
fi

BBlue='\033[1;34m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
ColorOff='\033[0m'

### Defaults
VERBOSE=

. $conf

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

    printf "${BBlue}PUB %s/%s${ColorOff}\n%s ...\n" $topic $channel $data

    mosquitto_pub -d -i $CLIENTID -h $HOST -p $PORT -u $USERNAME -P $PASSWORD -t $topic -m "$data" -q 1 &>$tmp
    rc=$?

    if [ $rc -eq 0 ]; then
        printf "${BGreen}ok\n"
        [ "$VERBOSE" ] && cat $tmp
    else
        printf "${BRed}"
        cat $tmp
    fi

    printf "${ColorOff}"

done
