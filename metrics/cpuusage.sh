###
### Average CPU usage
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
publish cpuusage $(vmstat | awk '/^[^a-z]+$/{print $13+$14}')
