###
### Running processes
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
awk '{gsub("[0-9]+/", ""); printf "process,%d", $4}' /proc/loadavg
