###
### System load last 5 min.
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
awk '{printf "cpu,%f", $1}' /proc/loadavg
