=begin
Заданы три числа, которые обозначают число, месяц, 
год (запрашиваем у пользователя). Найти порядковый номер даты, 
начиная отсчет с начала года. Учесть, что год может быть високосным. 
(Запрещено использовать встроенные в ruby методы для этого 
 вроде Date#yday или Date#leap?) Алгоритм опредления високосного 
 года: www.adm.yar.ru
=end
months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
data = []
%w(год месяц число).each_with_index do |item, index| 
  print "Введите #{item}: "
  data[index] = gets.chomp.to_i 
end
year, month, day = data
summ_days = 0
months.each_index {|index| summ_days += months[index] if index < month }
if year % 4 ==0 || year % 400 == 0  
  puts "\nГод високосный!"
  month > 2 ? summ_days+= day+1 : summ_days+= day 
else 
  puts "\nГод обычный!"
  summ_days+= day 
end
puts "Сначала года - #{summ_days}"