=begin
Идеальный вес. Программа запрашивает у пользователя имя и рост и выводит идеальный вес 
по формуле (<рост> - 110) * 1.15, 
после чего выводит результат пользователю на экран с обращением по имени. 
Если идеальный вес получается отрицательным, 
то выводится строка "Ваш вес уже оптимальный"
=end
BASE = 110
COEFF = 1.15
puts "Input your Name: " 
name = (gets.chomp).capitalize!
puts "Input your height in (cm): "
height = gets.chomp.to_i
weight_ideal = ((height - BASE) * COEFF).round(2)
puts weight_ideal < 0 ? "#{name}, your weight is optimal already!" : "#{name}, your ideal weight is - #{weight_ideal}"