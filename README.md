# picay
Simple Raspberry to Cayenne MQTT client

## Update Python and install Cayenne MQTT lib

    sudo apt-get -y install python-pip python-dev build-essential
    sudo pip install --upgrade pip virtualenv
    sudo pip install cayenne-mqtt

## Install & Setup

    cd
    git clone https://github.com/K-Ko/picay.git
    cd picay
    cp config.dist config.py

## Add Device on Cayenne

Go to your [Dashboard](https://cayenne.mydevices.com/cayenne/dashboard) and **Add new ...** > **Device/Widget**

Use **CAYENNE API** > **Bring Your Own Thing**

Edit now your `config.py` and set your **username**, **password** and **client id**

> Note: The username and password is unique for your account, the client id is different for each device.

## Test

    ./picay.sh

Now you should see on Cayenne the connected device.

Add to crontab

    crontab -e

    *    *    *    *    *    ~/picay/picay.sh >/dev/null 2>&1

## Selective send

Send all **except** disk usage and temperature (comma separated channel list starting with `-`)

    *    *    *    *    *    ~/picay/picay.sh -disk,temperature >/dev/null 2>&1

Send **only** disk usage and temperature (comma separated channel list)

    */5  *    *    *    *    ~/picay/picay.sh disk,temperature >/dev/null 2>&1

## Extend

Copy `metrics/.template.sh` to an own script and write your code.

See example for CPU frequency in the template file.
