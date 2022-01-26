
class Interface
  attr_accessor :rw, :menu

  def initialize(railway)
    @menu = {'menu' => ["Ввод данных", "Добавление/удаление элементов", 
                        "Перемещение поезда", "Списки элементов"],
    'menu_move' => ["Перемещение поезда"],
    'menu_create' => ["Создать станцию", "Создать поезд", "Создать маршрут"],
    'menu_change' => ["Добавить станцию к маршруту", "Исключить станцию из маршрута", 
                      "Назначить маршрут поезду", "Добавить/Удалить вагоны из поезда"], 
    'menu_list' => ["Список станций", "Список поездов", "Спискок маршрутов",
                    "Список поездов на станции"] }
    @rw = railway
  end
  
  def do_list
    begin
      print_menu(self.menu['menu'])
      case choice = validation_input(self.menu['menu'])
      when '1'
        menu_create  
      when '2'
        menu_change
      when '3'
        menu_move
      when '4'
        menu_list
      end
    end until choice == END_OPERATION  
  end
 
protected  
END_OPERATION = '0'

def menu_create
  begin  
    print_menu(self.menu['menu_create'])
    case choice = validation_input(self.menu['menu_create'])
    when  '1'
      station_create
    when '2'
      train_create
    when '3'
      route_create
    end
  end until choice == END_OPERATION  
end


def menu_change
  begin  
    print_menu(self.menu['menu_change'])
    case choice = validation_input(self.menu['menu_change'])
    when '1'
      add_station
    when '2'
      del_station
    when '3'
      set_route
    when '4'
      manage_car        
    end
  end until choice == END_OPERATION  
end

def menu_move
    move_train
end

def menu_list
  begin  
    print_menu(self.menu['menu_list'])
    case choice = validation_input(self.menu['menu_list'])
    when '1'
      stations_list
      pause
    when '2'
      trains_list
      pause
    when '3'
      routes_list
      pause
    when '4'
      trains_on_station_list       
      pause 
    end
  end until choice == END_OPERATION  
end

def print_menu(menu)
  system('clear')
  menu.each.with_index(1) {|item, index| puts "#{index} - #{item}"}
  print "Выбирайте пункт меню (1 - #{menu.length}), Выход - 0 : "  
end

def station_create 
  stations_list
  print 'Введите название новой станции: '
  station_title = gets.chomp.capitalize
  titles = []
  self.rw.stations.each {|station| titles << station.name}
  if titles.include?(station_title)
    puts "Станция уже существует" ; pause
  else
    self.rw.create_station(station_title)
    puts "#{self.rw.stations.last.name} - станция создана" ; pause
  end
end

def train_create
  trains_list
  print 'Введите номер поезда: '
  train_number = gets.chomp
  numbers = []
  self.rw.trains.each {|train| numbers << train.number}
  if numbers.include?(train_number) 
    (puts "Поезд #{train_number} существует") ; pause 
  else 
    choice = ''
    print 'Какой поезд создаем? (1 - пассажирский, 2 - грузовой): ' 
    choice = validation_input(1..2)
    if choice == '1' then self.rw.create_train(train_number, PassengerTrain) end
    if choice == '2' then self.rw.create_train(train_number, CargoTrain) end
    puts "Поезд #{self.rw.trains.last.number} создан" ; pause
  end
end

def route_create
  if self.rw.stations.length > 1
    routes_list if self.rw.routes.any?
    begin 
      stations_list
      print "Задайте станцию отправления (1 - #{self.rw.stations.length}): "
      station_start = validation_input(1..self.rw.stations.size).to_i - 1
      print "Задайте станцию прибытия (1 - #{self.rw.stations.size}): "
      station_end = validation_input(1..self.rw.stations.size).to_i - 1
      puts "Начальная и конечная станция должны отличаться!" if station_start == station_end
    end while station_start == station_end
    self.rw.create_route(station_start, station_end)
    puts "Маршрут создан \t#{self.rw.print_route(self.rw.routes.last)}"; pause
  else 
    puts "Недостаточно станций для создания маршрута"; pause
  end
end

def add_station
  if self.rw.routes.any? 
    self.rw.list_routes
    print "В какой маршрут добавляем? (1 - #{self.rw.routes.length}, Выход - 0): "
    choice = validation_input(1..self.rw.routes.length)
    index = choice.to_i - 1 
    begin
      puts self.rw.print_route(self.rw.routes[index])    
      self.rw.list_stations()
      print "Какую станцию добавляем? (1 - #{self.rw.stations.length}, Выход - 0): "
      choice_station = validation_input(1..self.rw.stations.length)
      unless choice_station == END_OPERATION
        index_station = choice_station.to_i - 1 
        self.rw.add_station_to_route(index, index_station)
      end
    end until (choice == END_OPERATION || choice_station == END_OPERATION)
  else
    puts "Нет маршрутов для редактирования" ; pause
  end
end

def del_station
  if self.rw.routes.any? 
    self.rw.list_routes
    print "Из какого маршрута удаляем? (1 - #{self.rw.routes.length}, Выход - 0) : " 
    choice = validation_input(1..self.rw.routes.length)
    index = choice.to_i - 1 
    begin
      puts self.rw.print_route(self.rw.routes[index])
      self.rw.routes[index].stations[1..-2].each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
      print "Какую станцию удаляем? (1 - #{self.rw.stations.size}, Выход - 0) : "
      choice_station = validation_input(1..self.rw.stations.size)
      unless choice_station == END_OPERATION
        index_station = choice_station.to_i 
        self.rw.del_station_from_route(index, index_station)
      end
    end until (choice == END_OPERATION || choice_station == END_OPERATION)
  else
    puts "Нет маршрутов для редактирования" ; pause
  end
end

def set_route
  unless self.rw.trains.empty? || self.rw.routes.empty?
    self.rw.list_routes
    print "Выбирайте маршрут, который будет назначен поезду (1 - #{self.rw.routes.size}): "
    choice_r = validation_input(1..self.rw.routes.size)
    route_index = choice_r.to_i - 1
    self.rw.list_trains
    print "Выбирайте поезд, которому будет назначен выбранный маршрут (1 - #{self.rw.trains.size}): "
    choice_t = validation_input(1..self.rw.trains.size)  
    train_index = choice_t.to_i - 1
    self.rw.set_route_to_train(train_index,route_index)
    puts " Маршрут << #{self.rw.print_route(self.rw.routes[route_index])} >> назначен  поезду #{self.rw.trains[train_index].number}"
    pause
  else
    puts"Нобходимо создать маршрут или поезд" ; pause
  end    
end

def manage_car
  unless self.rw.trains.empty? 
    self.rw.list_trains()
    print  "Какой поезд смотреть? (1 - #{self.rw.trains.size}, Выход -0): " 
    index_train = validation_input(1..self.rw.trains.size).to_i - 1
    train = self.rw.trains[index_train]
    begin 
      print "Добавить вагон - 1, Исключить вагон - 2, Выход - 0 :" 
      choice = validation_input(1..2)        
      self.rw.add_car_to_train(train) if choice == '1'
      self.rw.delete_car_from_train(train) if choice == '2'
    end until choice == END_OPERATION
  else
    puts "Необходимо создать поезд" ; pause
  end
end

def move_train
  unless self.rw.trains.empty? 
    trains_list
    print "Какой поезд будем двигать (1 - #{self.rw.trains.size}, Выход - 0): "
    choice = validation_input(1..self.rw.trains.size)
    train_index = choice.to_i - 1
    unless self.rw.trains[train_index].route.nil?
      begin 
        puts self.rw.print_route(self.rw.trains[train_index].route)
        puts "Текущая станция  -  #{self.rw.trains[train_index].current_station.name}"
        print "Двигаем: Вперед - 1, Назад - 2 , Выход - 0 : "
        choice = validation_input(1..2)
        self.rw.trains[train_index].move_forword if choice == '1'
        self.rw.trains[train_index].move_back if choice == '2'
      end until choice == END_OPERATION  
    else 
      puts "Необходимо задать поезду #{self.rw.trains[train_index].number} маршрут" ; pause
    end
  else
    puts "Необходимо создать поезд" ; pause
  end
end

def stations_list
  self.rw.list_stations
end

def trains_list
  self.rw.list_trains
end

def routes_list
  self.rw.list_routes
end

def trains_on_station_list
  unless self.rw.stations.empty?
    begin 
      stations_list 
      print "Какую станцию смотреть? (1 - #{self.rw.stations.size}, Выход - 0) : "
      choice = validation_input(1..self.rw.stations.size)
      unless choice == END_OPERATION
        index = choice.to_i - 1
        self.rw.list_trains_on_station(index)
      end
    end  unless choice == END_OPERATION
  else
    puts "Небходимо создать станцию" ; pause
  end
end

  def validation_input(data)
    data = data.to_a if data.class != Array 
    valid_data = ['0']
    data.each_index {|index|  valid_data << (index + 1).to_s}
    begin 
      choice = gets.chomp 
      valid_data.include?(choice) ? true : (print "Не верный ввод, еще раз : ") 
    end until valid_data.include?(choice)
    choice
  end

  def pause
    print "Для продолжения нажмите ввод"
    gets
  end
end