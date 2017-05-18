# picay
Simple Raspberry to Cayenne MQTT client

## Install mosquitto clients

    sudo apt-get update
    sudo apt-get -y install mosquitto-clients

## Install & Setup

    cd
    git clone https://github.com/K-Ko/picay.git
    cd picay
    cp picay.conf.dist picay.conf

## Add Device on Cayenne

Go to your [Dashboard](https://cayenne.mydevices.com/cayenne/dashboard) and **Add new ...** > **Device/Widget**

Use **CAYENNE API** > **Bring Your Own Thing**

Edit now your `config.conf` and set your **username**, **password** and **client id**

> Note: The username and password is unique for your account, the client id is different for each device.

## Test

    ./picay.sh

Now you should see on Cayenne the connected device.

Add to crontab

    crontab -e

    *    *    *    *    *    ~/picay/picay.sh &>/dev/null

## Selective send

Send all **except** disk and memory usage (comma separated channel list starting with `-`)

    */5   *    *    *    *    ~/picay/picay.sh -disk,memory &>/dev/null

Send **only** disk and memory usage (comma separated channel list)

    */10  *    *    *    *    ~/picay/picay.sh disk,memory &>/dev/null

## Extend

Copy `metrics/.template.sh` to an own script and write your code.

See example for CPU frequency in the template file.

To disable a metrics create a file `metrics/<metrics>.disabled`.
