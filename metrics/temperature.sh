###
### Core temperature
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
### Channel name will be build from file name (without .sh)
### Return only the channel value
###
TEMPERATURE_CELSIUS $(awk '{print $1/1000}' /sys/class/thermal/thermal_zone0/temp)
