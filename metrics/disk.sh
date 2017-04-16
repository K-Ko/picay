###
### Used space on /
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
df | awk '/\/$/{printf "disk,%f", $3/$2*100}'
