###
### Uptime in days
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
publish uptime $(awk '{print  $1/60/60/24}' /proc/uptime)
