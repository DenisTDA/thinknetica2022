#Заполнить массив числами фибоначчи до 100
fibonacci = [0,1]
while (next_item = fibonacci[-2] + fibonacci[-1]) <= 100
  fibonacci << next_item
end
print fibonacci