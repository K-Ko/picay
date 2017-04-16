#!/usr/bin/env python
import sys, os, argparse, time
import cayenne.client
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
import config

### Init command line arguments parser
parser = argparse.ArgumentParser(description="Cayenne MQTT client")
parser.add_argument("data", metavar="<channel>,<value>[,type,unit]", type=str, nargs="+", help="Data")
args = parser.parse_args()

### Start up
try:

    ### Any data given?
    if len(args.data) == 0: raise Exception("no data to send")

    ### Not yet done
    done = False

    ### The callback for when a message is received from Cayenne.
    def on_message(message):
        if message.msg_id == "done":
            ### The "done" message should be the last message so we set the done flag
            global done
            done = True

    ### Init Cayenne client
    client = cayenne.client.CayenneMQTTClient()
    client.on_message = on_message
    client.begin(config.USERNAME, config.PASSWORD, config.CLIENTID)

    ### Remember start time to check run time
    start = time.time()

    ### Wait until connected
    while not client.connected: client.loop()

    ### Sned all data tuples
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
        if done:
            break
        if (time.time() - start >= 10):
            raise Exception("timed out")

except Exception, e:
    print "Failed, " + str(e)
    sys.exit(1)

### Fine, all done
sys.exit(0)
