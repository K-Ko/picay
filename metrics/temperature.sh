###
### Core temperature
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
publish_celsius temperature $(awk '{print $1/1000}' /sys/class/thermal/thermal_zone0/temp)
