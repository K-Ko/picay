#!/bin/sh

#set -x

pwd=$(readlink -f $(dirname $0))
tmp=${1:-/tmp}

# Remove old data
rm -rf $tmp/$(basename $pwd) &>/dev/null

rsync -a "$pwd" "$tmp" --exclude .git --exclude docs

echo
echo "# Put this into your crontab:"
echo
echo "@reboot $pwd/$(basename $0) $tmp &>/dev/null"
echo

pwd=$(basename $pwd)

echo "# Send all metrics each 5 minutes"
echo "*/5   *  *  *  *  bash $tmp/$pwd/picay.sh &>/dev/null"
echo
echo "# Send all except disk usage and temperature"
echo "#*/2  *  *  *  *  bash $tmp/$pwd/picay.sh -disk,temperature &>/dev/null"
echo
echo "# Send only disk usage and temperature"
echo "#*/5  *  *  *  *  bash $tmp/$pwd/picay.sh disk,temperature &>/dev/null"
echo
