###
### Template for own metrics
###
### Copy and write your code :-)
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
### Channel name will be build from file name (without .sh)
### Return only the channel value
###
### Example to send current CPU frequency
###
#ANALOG_SENSOR_ANALOG $(awk '{print $1/1000}' /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq)
