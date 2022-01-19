=begin
Сумма покупок. Пользователь вводит поочередно название товара, 
цену за единицу и кол-во купленного товара (может быть нецелым числом). 
Пользователь может ввести произвольное кол-во товаров до тех пор, 
пока не введет "стоп" в качестве названия товара. 
На основе введенных данных требуетеся:

Заполнить и вывести на экран хеш, ключами которого являются названия товаров, 
а значением - вложенный хеш, содержащий цену за единицу товара и 
кол-во купленного товара. Также вывести итоговую сумму за каждый товар.
    
Вычислить и вывести на экран итоговую сумму всех покупок в "корзине".
=end
stop = ['stop', 'стоп']
input_end = false  
purchases = {}
total = 0.0
price_product = 0.0

until input_end
  print "Введите название товара: "
  title = gets.chomp 
  if stop.include?(title) 
    input_end = true
  else
    print "Введите цену за единицу товара: "
    price = gets.chomp.to_f
    print "Введите количество, укпленного товара: "
    count = gets.chomp.to_f
    price_product =  price * count 
    purchases[title] = {price: price, count: count, price_product: price_product} 
    total += price_product 
  end
end 
puts purchases
puts "Общая сумма покупок - #{total}"