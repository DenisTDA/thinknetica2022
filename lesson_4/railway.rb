class RailWay
  attr_accessor :routes, :trains, :stations
  END_OPERATION = '0'

  def initialize()
    @staions = []
    @trains = []
    @routes = []
  end

  def create_station
    list_stations
    print 'Введите название новой станции: '
    station_title = gets.chomp.capitalize
    titles = []
    @stations.each {|station| titles << station.name}
    if titles.include?(station_title)
      puts "Станция уже существует"
    else
      @stations << Station.new(station_title)
      puts "#{@stations.last.name} - станция создана"
    end
  end

  def create_train
    print 'Введите номер поезда: '
    train_number = gets.chomp
    print 'Какой поезд создаем? (1 - пассажирский, 2 - грузовой): '
    choice = gets.chomp
    if choice == '1' then @trains << PassengerTrain.new(train_number) end
    if choice == '2' then @trains << CargoTrain.new(train_number) end
    puts @trains.last    
  end

  def manage_route
    choice = ''
    until choice == END_OPERATION  
      print "Новый маршрут - 1, Добавить станцию в маршрут - 2, Удалить станцию из маршрута -3, Выход - 0 :" 
      choice = gets.chomp
      case choice 
      when '1'
        create_route()
      when '2'
        add_station_to_route
      when '3'
        del_station_from_route
      end
    end
  end

  def manage_car
    list_trains()
    print  "Какой поезд смотреть? (1 - #{@trains.length}): " 
    index_train = gets.chomp.to_i - 1
    train = @trains[index_train]
    choice = ''
    until choice == END_OPERATION
      print "Добавить вагон - 1, Исключить вагон - 2, Выход - 0 : "
      choice = gets.chomp
      add_car_to_train(train) if choice == '1'
      delete_car_from_train(train) if choice == '2'
    end
  end

  def set_route_to_train
    list_routes
    print "Выбирайте маршрут, который будет назначен поезду (1 - #{@routes.length}): "
    route_index = gets.chomp.to_i - 1
    list_trains
    print "Выбирайте поезд, которому будет назначен выбранный маршрут (1 - #{@trains.length}): "
    train_index = gets.chomp.to_i - 1
    @trains[train_index].set_route(@routes[route_index])
    puts " Маршрут << #{print_route(@routes[route_index])} >> назначен  поезду #{@trains[train_index].number}"
  end

  def move_train()
    list_trains
    print "Выбирайте поезд, который будем двигать (1 - #{@trains.length}): "
    train_index = gets.chomp.to_i - 1
    choice = ''
      until choice == END_OPERATION  
        puts print_route(@trains[train_index].route)
        puts "Текущая станция  -  #{@trains[train_index].current_station.name}"
        print "Двигаем: Вперед - 1, Назад - 2 , Выход - 0 : "
        choice = gets.chomp
        @trains[train_index].move_forword if choice == '1'
        @trains[train_index].move_back if choice == '2'
      end
  end

  def list_trains_on_station()
  choice = ''
    until choice == END_OPERATION
      list_stations() 
      print "Какую станцию смотреть? (1 - #{@stations.length}), Выход - 0 : "
      choice = gets.chomp.to_i - 1
      choice >= 0 ? @stations[choice].trains.each {|train| puts train} : choice = END_OPERATION
      pause unless choice == END_OPERATION
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
    choice = ''
    until choice == END_OPERATION
      list_menu()
      choice = gets.chomp
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
    end  
  end
  
  protected
  def list_stations
    puts "Список станций"
    @stations.each_index {|index| puts "#{index + 1} - #{@stations[index].name}"}
  end

  def list_trains
    puts "Список поездов"
    @trains.each_index {|index| puts "#{index + 1} - #{@trains[index].number}"}
  end
  
  def create_route
    list_stations()
    print "Задайте станцию отправления (1 - #{@stations.length}): "
    station_start = gets.chomp.to_i - 1
    print "Задайте станцию прибытия (1 - #{@stations.length}): "
    station_end = gets.chomp.to_i - 1
    @routes << Route.new(@stations[station_start], @stations[station_end])
    puts "Маршрут создан \t#{@routes.last.stations.first.name} --- #{@routes.last.stations.last.name}"
  end 
  
  def add_station_to_route
  list_routes()
    print "В какой маршрут добавляем? (1 - #{@routes.length}): " 
    if (choice = gets.chomp) != END_OPERATION
      choice = choice.to_i - 1
      puts print_route(@routes[choice])
      until choice == END_OPERATION
        list_stations()
        print "Какую станцию добавляем? (1 - #{@stations.length}), выход - 0: "
        index_station = gets.chomp.to_i - 1 
        if index_station >= 0 
          @routes[choice].insert(@stations[index_station])
          puts print_route(@routes[choice])
        else choice = END_OPERATION
        end
      end
    end
  end

  def del_station_from_route
    list_routes
    print "Из какого маршрута удаляем? (1 - #{@routes.length} :"
    if (choice = gets.chomp) != END_OPERATION
      choice = choice.to_i - 1
      puts print_route(@routes[choice])
      until choice == END_OPERATION
        @routes[choice].stations.each.with_index(1) {|station, index| puts "#{index} - #{station.name}"}
        print "Какую станцию добавляем? (1 - #{@stations.length}): "
        index_station = gets.chomp.to_i - 1 
        if index_station >= 0 
          @routes[choice].remove(@routes[choice].stations[index_station])
          puts print_route(@routes[choice])
        else choice = END_OPERATION
        end
      end
    end
  end

  def list_routes
    puts "Список маршрутов"
    @routes.each.with_index {|route, index| puts "#{index+1}.  " + print_route(route)}
  end

  def print_route(route)
    route_chain = ''
    route.stations.each.with_index do |station, index|
      if index.zero? 
        route_chain = "<#{station.name}>"
      else
        route_chain+= " -- <#{station.name}>"
      end
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
    print "Какую вагон отцепляем? (1 - #{train.carriages.length}): "
    car_index = gets.chomp.to_i - 1
    train.delete_car(train.carriages[car_index]) 
    print_cars(train)
  end

  def print_cars(train)
    train.carriages.each.with_index {|car, index| puts "#{index+1}. #{car}"}
  end
            
  def pause
    print "Для продолжения нажмите ввод"
    gets
  end
end