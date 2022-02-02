class RailWay
  attr_accessor :routes, :trains, :stations
  attr_reader :menu   
  
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @menu = {"main" => {"1" => "Input data" , "2" => "Change data", 
      "3" => "Move train", "4" => "Lists" },
      '1' => {'1' => 'Create station', '2' => 'Create train', '3' => 'Create route'} ,
      '2' => {'1'=>'Add station to route', '2'=>'Delete station from route', 
            '3'=>'Set route to  train', '4'=>'Add and delete carriages', '5' => 'Manage train'},
      '3' => {'1'=>''},
      '4' => {'1' => 'Stations list', '2' => 'Trains list', 
        '3' => 'Routes list', '4' => 'Trains on station', '5' => 'List stations with trains'},
      }

      @errors = {station_name: "Sation allredy exist!",
        no_stations: "Not enaugh stations for create route"}
  end
  
  def do_list
    begin
      print_menu(self.menu['main'])
      case choice = user_choice(self.menu['main'].keys)
      when '1'
        menu_create
      when '2'
        menu_change
      when '3'
        menu_move
      when '4'
        menu_list
      when '0'
        choice = END_OPERATION
      end
    end until choice == END_OPERATION
  end

  protected 
  attr_accessor :errors
  END_OPERATION = false  

  def print_menu(menu)
    system('clear')
    menu.each {|key, item | puts "#{key} - #{item}"}
    print "Выбирайте пункт меню (1 - #{menu.size}), Выход - 0 : "  
  end
    
  def menu_create
    begin  
      print_menu(self.menu['1'])
      case choice = user_choice(self.menu['1'].keys)
      when '1'
       create_station
      when '2'
        create_train
      when '3'
        create_route
      when '0'
        choice = END_OPERATION
      end
    end until choice == END_OPERATION  
  end
  
  def menu_change
    begin  
      print_menu(self.menu['2'])
      case choice = user_choice(self.menu['2'].keys)
      when '1'
        add_station
      when '2'
        del_station
      when '3'
        set_route
      when '4'
        manage_car 
      when '5'
        manage_train      
      when '0'
        choice = END_OPERATION
      end
    end until choice == END_OPERATION  
  end
  
  def menu_move
      move_train
  end
  
  def menu_list
    begin  
      print_menu(self.menu['4'])
      case choice = user_choice(self.menu['4'].keys)
      when '1'
        list_stations(self.stations)
        pause
       when '2'
        list_trains(self.trains)
        pause
       when '3'
        list_routes(self.routes)
        pause
       when '4'
        list_trains_on_station
        pause
      when '5'
        list_stations_with_trains
        pause
       when '0'
        choice = END_OPERATION       
       end
    end until choice == END_OPERATION  
  end
  
  def create_station
    list_stations(self.stations)
    print "Input station's name: "
    station_name = gets.chomp.upcase
    return if station_name == '0'
    stations.map {|station| raise self.errors[:station_name] if station.name.eql?(station_name)}
    self.stations << Station.new(station_name)
    puts "Station #{self.stations.last.name} was created"
    pause
  rescue => e
    puts e  
    retry 
  end

  def create_train
    type = {'1' => PassengerTrain, '2' => CargoTrain}
    list_trains(self.trains)
    print "Input train's number: "
    return if (train_number = gets.chomp.upcase) == '0'
    choice_type = choose_type_train 
    type[choice_type].nil? ? return : self.trains << type[choice_type].new(train_number)
    puts "#{print_train(self.trains.last)} - train was created"
    pause
  rescue => e
    puts e
    retry
  end

  def create_route
    raise self.errors[:no_stations] unless self.stations.size > 1
    list_routes(self.routes)
    list_stations(self.stations)
    station_start, station_end = set_stations_verified
    self.routes << Route.new(self.stations[station_start], self.stations[station_end])
    puts "Маршрут создан: #{self.print_route(self.routes.last)}" 
    pause
  rescue => e
    puts e
    retry
  end

  def add_station
    stations=[]
    return if (index_route = select_route) == END_OPERATION
    route = self.routes[index_route]
    self.stations.each {|station| stations << station unless route.stations.include?(station)}
    return if (station = select_station(route, stations)) == END_OPERATION
    route.insert(station)
    puts "Station <#{station.name}> was added to route #{print_route(route)}"
    pause
  rescue => e
    puts e
    retry
  end

  def select_route
    list_routes(self.routes)
    print "Choose the route for add (1 - #{self.routes.size}, Exit - 0): "
    index_route = choose_item(self.routes.size)
    puts print_route(self.routes[index_route]) if index_route
    index_route
  end

  def select_station(route,stations)
    list_stations(stations)
    print "Select station (1 - #{stations.size}, Exit - 0): "
    index_station = choose_item(stations.size)
    return END_OPERATION if index_station == END_OPERATION
    stations[index_station]
  end
 
  def remove_action(index_route, station)
    self.routes[index_route].remove(station)
    puts "Station <#{station.name}> was removed from route #{print_route(routes[index_route])}"
    pause
  end

  def stations_for_del(route)
    stations = []
    route.stations.each_with_index do |station, index| 
      stations << station unless index == 0 || index == route.stations.size - 1
    end
    stations
  end

  def del_station
    return if (index_route = select_route) == END_OPERATION
    stations = stations_for_del(self.routes[index_route])
    station =  select_station(self.routes[index_route], stations)
    return if station == END_OPERATION
    remove_action(index_route, station)
  end

  def set_route
      return if (index_route = select_route) == END_OPERATION
      return if (index_train = select_train) == END_OPERATION
      set_route_action(index_route, index_train)
    rescue => e
      puts e
      pause
      retry
  end

  def select_train
    unless list_trains(self.trains) == END_OPERATION
      print "Выбирайте поезд (1 - #{self.trains.size}): "
      choose_item(self.trains.size)
    else
      END_OPERATION
    end
  end

  def set_route_action(index_route, index_train)
    self.trains[index_train].set_route(self.routes[index_route])
    puts "Route #{print_route(self.routes[index_route])} set to the train #{self.trains[index_train].number}"
    pause
  end

  def move_train
    unless list_trains(self.trains) == END_OPERATION
      print "Какой поезд будем двигать (1 - #{self.trains.size}, Выход - 0): " 
      train_index = choose_item(self.trains.size)
      unless self.trains[train_index].route.nil?
        movment(train_index)
      else 
        puts "Необходимо задать поезду #{self.trains[train_index].number} маршрут"
        pause
      end
    end
  end

  def movment(train_index)
    begin 
      puts self.print_route(self.trains[train_index].route)
      puts "Текущая станция  -  #{self.trains[train_index].current_station.name}"
      print "Двигаем: Вперед - 1, Назад - 2 , Выход - 0 : "
      choice = user_choice(['1','2'])
      self.trains[train_index].move_forword if choice == '1'
      self.trains[train_index].move_back if choice == '2'
      choice = END_OPERATION if choice == '0'
    end until choice == END_OPERATION  
  end

  def set_stations_verified 
    begin 
      station_start, station_end = set_station('начальную'), set_station('конечную')
      puts "Начальная и конечная станция должны отличаться!" if station_start == station_end
    end while station_start == station_end
    [station_start,station_end]
  end

  def manage_car
    unless (index_train = select_train) == END_OPERATION
      train = self.trains[index_train]
      begin 
        print "Добавить вагон - 1, Исключить вагон - 2, Выход - 0 :" 
        choice = user_choice(['1','2'])
        add_car_to_train(train) if choice == '1'
        delete_car_from_train(train) if choice == '2'
        choice =END_OPERATION if choice == '0'
      end until choice == END_OPERATION 
    end
  end

  def select_car(train)
    unless list_carriages(train) == END_OPERATION
      print "Choose carriage (1 - #{train.carriages.size}): "
      choose_item(train.carriages.size)
    else
      END_OPERATION
    end
  end

  def manage_train
    unless (index_train = select_train) == END_OPERATION
      train = self.trains[index_train]
      unless (index_car = select_car(train)) == END_OPERATION
        car = train.carriages[index_car]
        begin
          print "Take up - 1, Release - 2, Exit - 0 :" 
          choice = user_choice(['1','2'])
          take_up_seat(car) if choice == '1' && car.class == CarPass
          take_up_capacity(car) if choice == '1' && car.class == CarCargo
          down_seat(car) if choice == '2' && car.class == CarPass
          down_capacity(car) if choice == '2' && car.class == CarCargo
          choice =END_OPERATION if choice == '0'
        end until choice == END_OPERATION 
      end
    end
  end

  def take_up_seat(car)
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
    car.take_seat
    puts "The seat was took up"
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
  end

  def take_up_capacity(car)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy}"
    print "Input value :"
    volume = gets.chomp.to_f 
    car.take_capacity(volume)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy} "
  rescue => e
    puts "Error input"
    retry
  end

  def down_seat(car)
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
    car.release_seat
    puts "The seat was released"
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
  end

  def down_capacity(car)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy}"
    print "Input value :"
    volume = gets.chomp.to_f 
    car.release_capacity(volume)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy} "
  rescue => e
    puts "Error input"
    retry
  end

  def add_car_to_train (train)
    puts print_train(train)
    if train.class == CargoTrain
      block = lambda {|param| param =~ /^(\d){3,5}(\W(\d){0,2})?$/ ? param.to_f : (raise "Wrone value!")}
      param = set_param_car(block) 
      train.add_car(CarCargo.new(param)) 
    end
    if train.class == PassengerTrain
      block = lambda {|param| param =~ /^\d{1,2}$/ ? param.to_i : (raise "Wrone value!")}
      param = set_param_car(block) 
      train.add_car(CarPass.new(param)) 
    end
    print_cars(train)
  end
  
  def set_param_car(block)
    print "Input capacity: "
    param = gets.chomp
    param = block.call(param)
  rescue => e
    puts  "#{e} Try again!"
    retry
    param
  end

  def delete_car_from_train(train)
    puts print_train(train)
    print_cars(train)
    print "Какой вагон отцепляем? (1 - #{train.carriages.size}): "
    index = choose_item(train.carriages.size)
    number_car = train.carriages[index].number
    train.delete_car(train.carriages[index]) unless index == END_OPERATION
    puts "Carriage №#{number_car} was deleted"
  end

  def set_station(text ='')
    print "Задайте станцию #{text} (1 - #{self.stations.size}): "
    choose_item(self.stations.size)
  end

  def choose_type_train
    print "To choose the type of train (1 - Passenger or 2 - Cargo): "
    user_choice(['1','2'])
  end
  def list_stations(stations)
    if stations.any? 
      puts "Список станций"
      stations.each.with_index(1) {|station, index| puts "#{index}. - #{station.name}"} 
    else
      puts "Список пуст"
      END_OPERATION
    end
  end

  def list_stations_with_trains
    if self.stations.any? 
      puts "Список станций"
      block = lambda {|train| puts print_train(train)}
      self.stations.each.with_index(1) do |station, index| 
        puts "\n#{index}. <#{station.name}>: "  
        station.each_train(block) 
      end
    else
      puts "Список пуст"
      END_OPERATION
    end
  end
  
  def list_trains(trains)
    if self.trains.any?
      puts "Список поездов"
      trains.each.with_index(1) {|train, index| puts "#{index}. " + print_train(train)}
    else
      puts "Список пуст"
      pause
      END_OPERATION
    end
  end

  def list_carriages(train)
    if train.carriages.any?
      puts "Список вагонов"
      print_cars(train)
    else
      puts "Список пуст"
      END_OPERATION
    end
  end

  def list_routes(routes)
    if self.routes.any?
      puts "Список маршрутов"
      routes.each.with_index(1) {|route, index| puts "#{index}.  " + print_route(route)} 
    else
      puts "Empty"
      return END_OPERATION
    end
  end

  def list_trains_on_station
    unless list_stations(self.stations) == END_OPERATION
      print "Make a choice (1 - #{self.stations.size}): "
      index_station = choose_item(self.stations.size)
      show_station(index_station) unless index_station == END_OPERATION
    end
  end 

  def show_station(index_station)
    if self.stations[index_station].trains.empty? 
      puts "No trains"
    else
      self.stations[index_station].trains.each {|train| puts print_train(train)}
    end
  end

  def choose_item(count_items)
    choices = []
    count_items.times {|item| choices << (item+1).to_s}
    choice = user_choice(choices)
    choice == '0' ? (return END_OPERATION) : (index = choice.to_i - 1)
    index
  end
 
  def print_train(train)
    train_info = "#{train.number} -- #{train.class}"
    train_info += " -- #{print_route(train.route)}" unless train.route.nil?
    train_info += " -- #{train.carriages.size}" if train.carriages.any?
    train_info
  end

  def print_route(route)
    route_info = ''
    route.stations.each_with_index do |station, index|
      index.zero? ? route_info = "<#{station.name}>" : route_info += " -- <#{station.name}>"
    end
    route_info
  end

  def print_cars(train)
    train.each_carriage do |carriage, index| 
      car_tail = " -- free: #{carriage.capacity_free} -- busy: #{carriage.capacity_busy}" if carriage.class == CarCargo 
      car_tail = " -- free: #{carriage.seats_free} -- busy: #{carriage.seats_busy}" if carriage.class == CarPass 
      puts "#{index}. № #{carriage.number} -- #{carriage.class}#{car_tail}"
    end
    
  end
  
  def user_choice(items)
    choice =''
    until items.include?(choice) || choice == '0'
      choice = gets.chomp
      print "Out of range. Once more :" unless items.include?(choice) || choice == '0'
    end 
    choice
  end

  def pause
    print "Для продолжения нажмите ввод"
    gets
  end
end