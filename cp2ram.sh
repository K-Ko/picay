#!/bin/sh

#set -x

pwd=$(readlink -f $(dirname $0))
tmp=${1:-/tmp}

rsync -a "$pwd" "$tmp" --exclude .git --exclude docs

echo
echo "Put this to your crontab:"
echo
echo "@reboot $pwd/$(basename $0) $tmp &>/dev/null"
echo
echo "# Send all metrics"
echo "*    *  *  *  *  bash $tmp/picay/picay.sh &>/dev/null"
echo
echo "# Send all except disk usage and temperature"
echo "#*/2  *  *  *  *  bash $tmp/picay/picay.sh -disk,temperature &>/dev/null"
echo
echo "# Send only disk usage and temperature"
echo "#*/5  *  *  *  *  bash $tmp/picay/picay.sh disk,temperature &>/dev/null"
echo
