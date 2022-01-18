=begin
Прямоугольный треугольник. Программа запрашивает у пользователя 3 стороны 
треугольника и определяет, является ли треугольник прямоугольным (используя 
теорему Пифагора www-formula.ru), равнобедренным 
(т.е. у него равны любые 2 стороны)  или равносторонним (все 3 стороны равны) 
и выводит результат на экран. Подсказка: чтобы воспользоваться теоремой Пифагора, 
нужно сначала найти самую длинную сторону (гипотенуза) и сравнить ее значение
 в квадрате с суммой квадратов двух остальных сторон. Если все 3 стороны равны, 
 то треугольник равнобедренный и равносторонний, но не прямоугольный.
=end

triangle =[]
3.times do |x|
  puts "Input #{x+1} side: "
  triangle[x] = gets.chomp.to_f
end  
squares = triangle.sort.map{|x| x**2}
if triangle[0]+triangle[1] > triangle [2] && 
   triangle[1]+triangle[2] > triangle [0] &&
   triangle [0] + triangle[2] > triangle [1]

    if triangle[0]== triangle[1] && triangle[1] == triangle[2]
      puts "Triangle is equilateral"
    elsif triangle[0] ==triangle[1]  || triangle[1] == triangle[2] || triangle[0] ==triangle[1] 
      puts "Triangle is isosceles"
    elsif squares[2] == squares[1] + squares[0]
      puts "Triangle is rectangular"
    else
      puts "Triangle is simple" 
    end
else 
  puts "Trianle not exist"    
end