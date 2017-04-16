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
### Example to get current CPU frequency
###
### Just return your metrics in format
### <channel>,<value>[,type,unit]
###
#awk '{printf "freq,%d", $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
