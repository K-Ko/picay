#!/usr/bin/env bash
###
### Simple Raspberry to Cayenne MQTT client
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###

### --------------------------------------------------------------------------
BBlue='\033[1;34m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
ColorOff='\033[0m'

### --------------------------------------------------------------------------
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

. $pwd/datatypes.sh

[ "$VERBOSE" ] || echo -e "${BGreen}Broker $HOST:$PORT${ColorOff}\n"

### Read metrics scripts
for script in $pwd/metrics/*.sh; do
    channel=$(basename $script | sed 's/\.sh$//')

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

    ### Publish data
    data=$(. $script)

    ### Silently skip empty data
    [ "$data" ] || continue

    topic="v1/$USERNAME/things/$CLIENTID/data/$channel"

    echo -en "${BBlue}PUB $topic${ColorOff}\n$data ... "

    echo "Broker $HOST:$PORT" >$tmp

    mosquitto_pub -d -q ${QOS:-1} -i $CLIENTID -h $HOST -p $PORT -r \
                  -u $USERNAME -P $PASSWORD -t $topic -m "$data" &>>$tmp
    rc=$?
    # -4: MQTT_CONNECTION_TIMEOUT - the server didn't respond within the keepalive time
    # -3: MQTT_CONNECTION_LOST - the network connection was broken
    # -2: MQTT_CONNECT_FAILED - the network connection failed
    # -1: MQTT_DISCONNECTED - the client is disconnected cleanly
    #  0: MQTT_CONNECTED - the cient is connected
    #  1: MQTT_CONNECT_BAD_PROTOCOL - the server doesn't support the requested version of MQTT
    #  2: MQTT_CONNECT_BAD_CLIENT_ID - the server rejected the client identifier
    #  3: MQTT_CONNECT_UNAVAILABLE - the server was unable to accept the connection
    #  4: MQTT_CONNECT_BAD_CREDENTIALS - the username/password were rejected
    #  5: MQTT_CONNECT_UNAUTHORIZED - the client was not authorized to connect

    echo -en "\b\b\b\b"

    if [ $rc -eq 0 ]; then
        echo -e "${BGreen}- ok"
        [ "$VERBOSE" ] && cat $tmp 2>/dev/null
    else
        echo -e "${BRed}- fail ($rc)"
        cat $tmp 2>/dev/null
    fi

    echo -en "${ColorOff}"
done
