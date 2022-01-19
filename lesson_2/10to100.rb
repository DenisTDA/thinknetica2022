# Заполнить массив числами от 10 до 100 с шагом 5
my_array = Array.new
(10..100).step(5) {|x| my_array << x}
print my_array