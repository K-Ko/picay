#!/bin/sh

#set -x

pwd=$(readlink -f $(dirname $0))

[ -z "$1" ] && printf "\nUsage: $0 <temp. dir>\n\n" && exit 1

rsync -a "$pwd" "$1" --exclude .git --exclude docs

echo
echo "Put this to your crontab:"
echo
echo "@reboot $pwd/$(basename $0) $1 >/dev/null"
echo
echo "# Send all metrics"
echo "*    *  *  *  *  bash $1/picay/picay.sh >/dev/null"
echo
echo "# Send all except disk usage and temperature"
echo "#*    *  *  *  *  bash $1/picay/picay.sh -disk,temperature >/dev/null"
echo
echo "# Send only disk usage and temperature"
echo "#*/5  *  *  *  *  bash $1/picay/picay.sh disk,temperature >/dev/null"
echo
