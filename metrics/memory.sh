###
### Real used memory
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  (c) 2016 Knut Kohl
### @licence    MIT License - http://opensource.org/licenses/MIT
###
publish memory $(free | awk '/-\/+/{print (1-$4/($3+$4))*100}')
