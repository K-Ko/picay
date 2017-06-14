###
### Template for own metrics
###
### Copy and write your code :-)
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###

###
### Example to send current CPU frequency
###
### Generic publishing:
###
###     publish <channel> <value>
###
### See cayenne.sh for special publishing functions
###
#publish frequency $(awk '{print $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
