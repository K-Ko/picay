### --------------------------------------------------------------------------
### https://github.com/myDevicesIoT/Cayenne-MQTT-Python/blob/master/cayenne/client.py
### Rewrite from Python to bash
### --------------------------------------------------------------------------

### --------------------------------------------------------------------------
### Data types
### --------------------------------------------------------------------------
TYPE_BAROMETRIC_PRESSURE=bp        # Barometric pressure
TYPE_BATTERY=batt                  # Battery
TYPE_LUMINOSITY=lum                # Luminosity
TYPE_PROXIMITY=prox                # Proximity
TYPE_RELATIVE_HUMIDITY=rel_hum     # Relative Humidity
TYPE_TEMPERATURE=temp              # Temperature
TYPE_VOLTAGE=voltage               # Voltage

### --------------------------------------------------------------------------
### Unit types
### --------------------------------------------------------------------------
UNIT_PASCAL=pa                     # Pascal
UNIT_HECTOPASCAL=hpa               # Hectopascal
UNIT_PERCENT=p                     # % (0 to 100)
UNIT_RATIO=r                       # Ratio
UNIT_VOLTS=v                       # Volts
UNIT_LUX=lux                       # Lux
UNIT_CENTIMETER=cm                 # Centimeter
UNIT_METER=m                       # Meter
UNIT_DIGITAL=d                     # Digital (0/1)
UNIT_FAHRENHEIT=f                  # Fahrenheit
UNIT_CELSIUS=c                     # Celsius
UNIT_KELVIN=k                      # Kelvin
UNIT_MILLIVOLTS=mv                 # Millivolts

### --------------------------------------------------------------------------
BBlue='\033[1;34m'
BRed='\033[1;31m'
BGreen='\033[1;32m'
ColorOff='\033[0m'

### --------------------------------------------------------------------------
### Send data to Cayenne.
### $1 - channel
### $2 - value
### $3 - data type ($TYPE_..., optional)
### $4 - data unit ($UNIT_..., optional)
### --------------------------------------------------------------------------
function publish () {
    local channel=$1
    local data=$2
    local type=$3
    local unit=$4

    ### Skip empty data
    [ "$data" ] || return

    topic="v1/$USERNAME/things/$CLIENTID/data/$channel"

    ### Reformat if a data type was given
    [ "$type" ] && data="$type,$unit=$data"

    echo "Broker $HOST:$PORT" >$tmp

    echo -ne "${BBlue}PUB $topic${ColorOff}\n$data ... "

    mosquitto_pub -d -q 1 -i $CLIENTID -h $HOST -p $PORT \
                  -u $USERNAME -P $PASSWORD -t $topic -m "$data" &>>$tmp

    rc=$?

#     -4: MQTT_CONNECTION_TIMEOUT - the server didn't respond within the keepalive time
#     -3: MQTT_CONNECTION_LOST - the network connection was broken
#     -2: MQTT_CONNECT_FAILED - the network connection failed
#     -1: MQTT_DISCONNECTED - the client is disconnected cleanly
#      0: MQTT_CONNECTED - the cient is connected
#      1: MQTT_CONNECT_BAD_PROTOCOL - the server doesn't support the requested version of MQTT
#      2: MQTT_CONNECT_BAD_CLIENT_ID - the server rejected the client identifier
#      3: MQTT_CONNECT_UNAVAILABLE - the server was unable to accept the connection
#      4: MQTT_CONNECT_BAD_CREDENTIALS - the username/password were rejected
#      5: MQTT_CONNECT_UNAUTHORIZED - the client was not authorized to connect

    echo -en "\b\b\b\b"

    if [ $rc -eq 0 ]; then
        echo -e "${BGreen}- ok"
        [ "$VERBOSE" ] && cat $tmp 2>/dev/null
    else
        echo -e "${BRed}- fail ($rc)"
        cat $tmp 2>/dev/null
    fi

    echo -e "${ColorOff}"
}

### --------------------------------------------------------------------------
### Send a Celsius value to Cayenne.
### $1 - channel
### $2 - value
### --------------------------------------------------------------------------
function publish_celsius () {
    publish $1 $2 $TYPE_TEMPERATURE $UNIT_CELSIUS
}

### --------------------------------------------------------------------------
### Send a Fahrenheit value to Cayenne.
### $1 - channel
### $2 - value
### --------------------------------------------------------------------------
function publish_fahrenheit () {
    publish $1 $2 $TYPE_TEMPERATURE $UNIT_FAHRENHEIT
}

### --------------------------------------------------------------------------
### Send a Kelvin value to Cayenne.
### $1 - channel
### $2 - value
### --------------------------------------------------------------------------
function publish_kelvin () {
    publish $1 $2 $TYPE_TEMPERATURE $UNIT_KELVIN
}

### --------------------------------------------------------------------------
### Send a Lux value to Cayenne.
### $1 - channel
### $2 - value
### --------------------------------------------------------------------------
function publish_lux () {
    publish $1 $2 $TYPE_LUMINOSITY $UNIT_LUX
}

### --------------------------------------------------------------------------
### Send a Pascal value to Cayenne.
### $1 - channel
### $2 - value
### --------------------------------------------------------------------------
function publish_pascal () {
    publish $1 $2 $TYPE_BAROMETRIC_PRESSURE $UNIT_PASCAL
}

### --------------------------------------------------------------------------
### Send a Hectopascal value to Cayenne.
### $1 - channel
### $2 - value
### --------------------------------------------------------------------------
function publish_hectopascal () {
    publish $1 $2 $TYPE_BAROMETRIC_PRESSURE $UNIT_HECTOPASCAL
}
