#!/usr/bin/env bash
###
### Simple Raspberry to Cayenne MQTT client
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###

pwd=${0%/*}
conf=$pwd/picay.conf

[ ! -s $conf ] && echo "Missing configuration file $conf" && exit

if [ "$1" ]; then
    ### If there is a parameter starting with '-',
    ### exclude channels otherwise only send defined channels
    [ "${1:0:1}" != - ] && include="$1," || exclude="${1:1},"
fi

### Use PID file for only run one script at the same time
pid=/tmp/picay.$(echo $@ | md5sum | cut -b-8).pid

if ln -s "pid=$$" $pid 2>/dev/null; then
    tmp=$(mktemp)
    trap "rm $pid $tmp 2>/dev/null" 0 1 2 3 15
else
    echo "Lock file $pid exists, exit"
    exit
fi

### --------------------------------------------------------------------------
### Defaults
HOST=mqtt.mydevices.com
PORT=1883
QOS=1
VERBOSE=

. $conf

### Check required parameters
[ -z "$HOST" ]     && echo 'Missing broker host name!' && exit 1
[ -z "$PORT" ]     && echo 'Missing broker host port!' && exit 1
[ -z "$CLIENTID" ] && echo 'Missing client id!'  && exit 1
[ -z "$USERNAME" ] && echo 'Missing unser name!' && exit 1
[ -z "$PASSWORD" ] && echo 'Missing password!'   && exit 1

. $pwd/cayenne.sh

[ "$VERBOSE" ] || echo -e "${BGreen}Broker $HOST:$PORT${ColorOff}\n"

### Read metrics scripts
for script in $pwd/metrics/*.sh; do

    channel=$(basename $script | sed 's/\.sh//g')

    if [ -f $(dirname $script)/$channel.disabled ]; then
        echo -e "${BGreen}Skip $channel, disabled"
        continue
    fi

    if [ "$include" ]; then
        echo $include | grep -q "$channel,"
        [ $? -eq 0 ] || continue
    elif [ "$exclude" ]; then
        echo $exclude | grep -q "$channel,"
        [ $? -eq 0 ] && continue
    fi

    ### Run script
    . $script

done
