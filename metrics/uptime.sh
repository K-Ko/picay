###
### Uptime in days
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
### Channel name will be build from file name (without .sh)
### Return only the channel value
###
ANALOG_SENSOR_ANALOG $(awk '{print  $1/60/60/24}' /proc/uptime)
