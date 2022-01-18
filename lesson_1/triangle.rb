=begin
Площадь треугольника. Площадь треугольника можно вычислить, 
зная его основание (a) и высоту (h) по формуле: 1/2*a*h. 
Программа должна запрашивать основание и высоту треугольника 
и возвращать его площадь.
=end
puts "Input triangle's base : "
base = gets.chomp.to_f
puts "Input triangle's height: "
height = gets.chomp.to_f
square = 0.5 * base * height
print "Base = #{base}, height = #{height}, square = #{square}" 