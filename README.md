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

Edit `config.py` and set your username, password and client id

Test

    ./picay.sh

Add to crontab

    crontab -e

    *    *    *    *    *    ~/picay/picay.sh >/dev/null 2>&1

## Selective send

Send all **except** disk usage and temperature

    *    *    *    *    *    ~/picay/picay.sh -disk,temperature >/dev/null 2>&1

Send **only** disk usage and temperature

    */5  *    *    *    *    ~/picay/picay.sh disk,temperature >/dev/null 2>&1

## Extend

Copy `metrics/.template.sh` to an own script and write your code.

See example for CPU frequency in the template file.
