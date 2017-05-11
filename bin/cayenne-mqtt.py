#!/usr/bin/env python
###
### Simple Raspberry to Cayenne MQTT client
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
import sys, os, argparse
import cayenne.client

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import config

### Init command line arguments parser
parser = argparse.ArgumentParser(description="Cayenne MQTT client")
parser.add_argument("data", metavar="<channel>,<value>[,type,unit]", type=str, nargs="+", help="Data")
args = parser.parse_args()

### The callback for when a message is received from Cayenne.
def on_message(message):
    if message.msg_id == "done":
        ### The "done" message IS the last message, exit
        sys.exit(0)

### Start up
try:

    ### Any data given?
    if len(args.data) == 0: raise Exception("no data to send")

    ### Init Cayenne client
    client = cayenne.client.CayenneMQTTClient()
    client.on_message = on_message
    client.begin(config.USERNAME, config.PASSWORD, config.CLIENTID)

    ### Wait until connected, required to send message in order
    while not client.connected: client.loop()

    ### Remember start time to check run time
    start = time.time()

    ### Send all data tuples
    for arg in args.data:
        v = arg.split(",")

        if len(v) == 2:
            ### No type & unit
            dataUnit = ""
            dataType = ""
        elif len(v) == 4:
            ### Type & unit given
            dataUnit = v[2]
            dataType = v[3]
        else:
            raise Exception("invalid data: " + str(arg))

        client.virtualWrite(v[0], v[1], dataType, dataUnit)

    ### All done, send flag messge
    client.mqttPublish(client.rootTopic + "/cmd/1", "done,1")

    ### Wait until done but max. 10 seconds
    while True:
        client.loop()
        if (time.time() - start >= 10):		
            raise Exception("timed out")

except Exception, e:
    print "Failed, " + str(e)
    sys.exit(1)

### Fine, all done
sys.exit(0)
