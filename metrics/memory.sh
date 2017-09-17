###
### Real used memory
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
### Channel name will be build from file name (without .sh)
### Return only the channel value
###
MEMORY_PERCENT $(free | awk '/-\/+/{print (1-$4/($3+$4))*100}')
