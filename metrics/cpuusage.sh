###
### Average CPU usage
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
### Channel name will be build from file name (without .sh)
### Return only the channel value
###
CPU_PERCENT $(vmstat | awk '/^[^a-z]+$/{print $13+$14}')
