class RailWay
 #По хорошему надо attr_accessor  переместить в protect, но для seed оставил здесь. 
  attr_accessor :routes, :trains, :stations  
  END_OPERATION = '0'

  def initialize()
    @stations = []
    @trains = []
    @routes = []
  end

  def create_station
    self.stations.empty? ?  true : list_stations
    print 'Введите название новой станции: '
    station_title = gets.chomp.capitalize
    titles = []
    self.stations.each {|station| titles << station.name}
    if titles.include?(station_title)
      puts "Станция уже существует" ; pause
    else
      self.stations << Station.new(station_title)
      puts "#{self.stations.last.name} - станция создана" ; pause
    end
  end

  def create_train
    print 'Введите номер поезда: '
    train_number = gets.chomp
    choice = ''
    (print 'Какой поезд создаем? (1 - пассажирский, 2 - грузовой): ' ; choice = gets.chomp ) until %w(1 2).include?(choice)
    if choice == '1' then self.trains << PassengerTrain.new(train_number) end
    if choice == '2' then self.trains << CargoTrain.new(train_number) end
    puts "Поезд #{self.trains.last.number} создан" ; pause
  end

  def manage_route
    unless self.stations.length < 2 
      begin   
        choice = ''
        (print "Новый маршрут - 1, Добавить станцию в маршрут - 2, Удалить станцию из маршрута -3, Выход - 0 : "; choice = gets.chomp ) until %w(1 2 3 0).include?(choice)
        case choice 
        when '1'
          create_route()
        when '2'
          self.routes.empty? ? (puts "Необходимо создать маршрут или добавить станции" ; pause) : add_station_to_route
        when '3'
          self.routes.empty? ? (puts "Необходимо создать маршрут" ; pause) : del_station_from_route
        end
      end until choice == END_OPERATION
    else 
      puts "Необходимо создать станции" ; pause
    end 
  end

  def manage_car
    unless self.trains.empty? 
      list_trains()
      print  "Какой поезд смотреть? (1 - #{self.trains.length}): " 
      index_train = gets.chomp.to_i - 1
      train = self.trains[index_train]
      choice = ''
      begin 
        (print "Добавить вагон - 1, Исключить вагон - 2, Выход - 0 : "; choice = gets.chomp ) until %w(1 2 0).include?(choice)
        add_car_to_train(train) if choice == '1'
        delete_car_from_train(train) if choice == '2'
      end until choice == END_OPERATION
    else
      puts "Необходимо создать поезд" ; pause
    end
  end

  def set_route_to_train
    unless self.trains.empty? || self.routes.empty?
      list_routes
      print "Выбирайте маршрут, который будет назначен поезду (1 - #{self.routes.length}): "
      route_index = gets.chomp.to_i - 1
      list_trains
      print "Выбирайте поезд, которому будет назначен выбранный маршрут (1 - #{self.trains.length}): "
      train_index = gets.chomp.to_i - 1
      self.trains[train_index].set_route(self.routes[route_index])
      puts " Маршрут << #{print_route(self.routes[route_index])} >> назначен  поезду #{self.trains[train_index].number}"
    else
      puts"Нобходимо создать маршрут или поезд" ; pause
    end
  end

  def move_train()
    unless self.trains.empty? 
      list_trains
      print "Выбирайте поезд, который будем двигать (1 - #{self.trains.length}): "
      train_index = gets.chomp.to_i - 1
      choice = ''
      unless self.trains[train_index].route.nil?
        begin 
          puts print_route(self.trains[train_index].route)
          puts "Текущая станция  -  #{self.trains[train_index].current_station.name}"
          print "Двигаем: Вперед - 1, Назад - 2 , Выход - 0 : "
          choice = gets.chomp
          self.trains[train_index].move_forword if choice == '1'
          self.trains[train_index].move_back if choice == '2'
        end until choice == END_OPERATION  
      else 
        puts "Необходимо задать поезду #{self.trains[train_index].number} маршрут" ; pause
      end
    else
      puts "Необходимо создать поезд" ; pause
    end
  end

  def list_trains_on_station()
    unless self.trains.empty? || self.stations.empty?
      begin 
        list_stations() 
        print "Какую станцию смотреть? (1 - #{self.stations.length}), Выход - 0 : "
        choice = gets.chomp.to_i - 1 until (1..self.stations.length).include?(choice)
        choice >= 0 ? self.stations[choice].trains.each {|train| puts train} : choice = END_OPERATION
        pause unless choice == END_OPERATION
      end until choice == END_OPERATION
    else
      puts "Небходимо создать поезд или станцию" ; pause
    end
  end

  def list_menu()
    menu = ["Создать станцию", 
      "Создать поезд", "Управление маршрутами", 
      "Назначить маршрут поезду", "Распределение вагонов", 
      "Задать движение поезда", "Просмотреть состояние станции"]
    menu.each.with_index(1)  {|item, index| puts "#{index} - #{item}"}
    print "Что будем делать? (1 - #{menu.length}), Выход - 0 : "  
  end

  def do_list
    begin
      system('clear')
      list_menu()
      choice = ''
      begin 
        system('clear')
        list_menu()
        choice = gets.chomp 
      end until %w(1 2 3 4 5 6 7 0).include?(choice)
      case choice
        when '1'
          create_station()
        when '2'
          create_train()
        when '3'
          manage_route()
        when '4'
          set_route_to_train()
        when '5'
          manage_car()
        when '6'
          move_train()
        when '7'
          list_trains_on_station()
      end
    end until choice == END_OPERATION  
  end
  
  protected

  def list_stations
    puts "Список станций"
    self.stations.each_index {|index| puts "#{index + 1} - #{self.stations[index].name}"}
  end

  def list_trains
    puts "Список поездов"
    self.trains.each_index {|index| puts "#{index + 1} - #{self.trains[index].number}"}
  end
  
  def create_route
    begin 
      list_stations()
      print "Задайте станцию отправления (1 - #{self.stations.length}): "
      station_start = gets.chomp.to_i - 1
      print "Задайте станцию прибытия (1 - #{self.stations.length}): "
      station_end = gets.chomp.to_i - 1
      puts "Начальная и конечная станция должны отличаться!" if station_start == station_end
    end while station_start == station_end
    self.routes << Route.new(self.stations[station_start], self.stations[station_end])
    puts "Маршрут создан \t#{print_route(self.routes.last)}"
  end
  
  def add_station_to_route
  list_routes()
    print "В какой маршрут добавляем? (1 - #{self.routes.length}): "
    if (choice = gets.chomp) != END_OPERATION
      choice = choice.to_i - 1
      puts print_route(self.routes[choice])
      until choice == END_OPERATION
        list_stations()
        print "Какую станцию добавляем? (1 - #{self.stations.length}), выход - 0: "
        index_station = gets.chomp.to_i - 1
        if index_station >= 0
          self.routes[choice].insert(self.stations[index_station])
          puts print_route(self.routes[choice])
        else choice = END_OPERATION
        end
      end
    end
  end

  def del_station_from_route
    list_routes
    print "Из какого маршрута удаляем? (1 - #{self.routes.length} :"
    if (choice = gets.chomp) != END_OPERATION
      choice = choice.to_i - 1
      puts print_route(self.routes[choice])
      until choice == END_OPERATION
        self.routes[choice].stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
        print "Какую станцию добавляем? (1 - #{self.stations.length}): "
        index_station = gets.chomp.to_i - 1 
        if index_station >= 0 
          self.routes[choice].remove(self.routes[choice].stations[index_station])
          puts print_route(self.routes[choice])
        else choice = END_OPERATION
        end
      end
    end
  end

  def list_routes
    puts "Список маршрутов"
    self.routes.each.with_index(1) {|route, index| puts "#{index}.  " + print_route(route)}
  end

  def print_route(route)
    route_chain = ''
    route.stations.each.with_index do |station, index|
      index.zero? ? route_chain = "<#{station.name}>" : route_chain+= " -- <#{station.name}>"
    end
    route_chain
  end
     
  def add_car_to_train (train)
    puts train.number
    train.add_car(CarCargo.new()) if train.class == CargoTrain 
    train.add_car(CarPass.new()) if train.class == PassengerTrain
    print_cars(train)
  end
    
  def delete_car_from_train(train)
    puts train.number
    print "Какой вагон отцепляем? (1 - #{train.carriages.length}): "
    car_index = gets.chomp.to_i - 1
    train.delete_car(train.carriages[car_index]) 
    print_cars(train)
  end

  def print_cars(train)
    train.carriages.each.with_index(1) {|car, index| puts "#{index}. #{car}"}
  end
            
  def pause
    print "Для продолжения нажмите ввод"
    gets
  end
end