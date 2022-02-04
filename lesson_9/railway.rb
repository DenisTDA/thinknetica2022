class RailWay
  attr_accessor :routes, :trains, :stations
  attr_reader :menu

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @menu = { 'main' => { '1' => 'Input data', '2' => 'Change data',
                          '3' => 'Move train', '4' => 'Lists' },
              'create' => { '1' => 'Create station', '2' => 'Create train', '3' => 'Create route' },
              'change' => { '1' => 'Add station to route', '2' => 'Delete station from route',
                            '3' => 'Set route to  train', '4' => 'Add and delete carriages', '5' => 'Manage train' },
              'move' => {},
              'list' => { '1' => 'Stations list', '2' => 'Trains list',
                          '3' => 'Routes list', '4' => 'Trains on station', '5' => 'List stations with trains' } }

    @errors = { station_name: 'Sation allredy exist!',
                no_stations: 'Not enaugh stations for create route' }
  end

  def do_list
    loop do
      print_menu(menu['main'])
      case user_choice(menu['main'].keys)
      when '1'
        menu_create
      when '2'
        menu_change
      when '3'
        menu_move
      when '4'
        menu_list
      when '0'
        break
      end
    end
  end

  protected

  END_OPERATION = false

  attr_accessor :errors

  def print_menu(menu)
    system('clear')
    menu.each { |key, item| puts "#{key} - #{item}" }
    print "Выбирайте пункт меню (1 - #{menu.size}), Выход - 0 : "
  end

  def menu_create
    loop do
      print_menu(menu['create'])
      case user_choice(menu['create'].keys)
      when '1'
        create_station
      when '2'
        create_train
      when '3'
        create_route
      when '0'
        break
      end
    end
  end

  def menu_change
    loop do
      print_menu(menu['change'])
      case user_choice(menu['change'].keys)
      when '1'
        add_station
      when '2'
        del_station
      when '3'
        assign_route
      when '4'
        manage_car
      when '5'
        manage_train
      when '0'
        break
      end
    end
  end

  def menu_move
    move_train
  end

  def menu_list
    loop do
      print_menu(menu['list'])
      case user_choice(menu['list'].keys)
      when '1'
        list_stations(stations)
        pause
      when '2'
        list_trains(trains)
        pause
      when '3'
        list_routes(routes)
        pause
      when '4'
        list_trains_on_station
        pause
      when '5'
        list_stations_with_trains
        pause
      when '0'
        break
      end
    end
  end

  def create_station
    list_stations(stations)
    print "Input station's name: "
    station_name = gets.chomp.upcase
    return if station_name == '0'

    stations.map { |station| raise errors[:station_name] if station.name.eql?(station_name) }
    stations << Station.new(station_name)
    puts "Station #{stations.last.name} was created"
    pause
  rescue StandardError => e
    puts e
    retry
  end

  def create_train
    type = { '1' => PassengerTrain, '2' => CargoTrain }
    list_trains(trains)
    print "Input train's number: "
    return if (train_number = gets.chomp.upcase) == '0'

    choice_type = choose_type_train
    type[choice_type].nil? ? return : trains << type[choice_type].new(train_number)

    puts "#{print_train(trains.last)} - train was created"
    pause
  rescue StandardError => e
    puts e
    retry
  end

  def create_route
    raise errors[:no_stations] unless stations.size > 1

    list_routes(routes)
    list_stations(stations)
    station_start, station_end = choose_stations_verified
    routes << Route.new(stations[station_start], stations[station_end])
    puts "Маршрут создан: #{print_route(routes.last)}"
    pause
  rescue StandardError => e
    puts e
    retry
  end

  def add_station
    stations = []
    return if (index_route = select_route) == END_OPERATION

    route = routes[index_route]
    self.stations.each { |station| stations << station unless route.stations.include?(station) }
    return if (station = select_station(route, stations)) == END_OPERATION

    route.insert(station)
    puts "Station <#{station.name}> was added to route #{print_route(route)}"
    pause
  rescue StandardError => e
    puts e
    retry
  end

  def select_route
    list_routes(routes)
    print "Choose the route for add (1 - #{routes.size}, Exit - 0): "
    index_route = choose_item(routes.size)
    puts print_route(routes[index_route]) if index_route
    index_route
  end

  def select_station(_route, stations)
    list_stations(stations)
    print "Select station (1 - #{stations.size}, Exit - 0): "
    index_station = choose_item(stations.size)
    return END_OPERATION if index_station == END_OPERATION

    stations[index_station]
  end

  def remove_action(index_route, station)
    routes[index_route].remove(station)
    puts "Station <#{station.name}> was removed from route #{print_route(routes[index_route])}"
    pause
  end

  def stations_for_del(route)
    stations = []
    route.stations.each_with_index do |station, index|
      stations << station unless index.zero? || index == route.stations.size - 1
    end
    stations
  end

  def del_station
    return if (index_route = select_route) == END_OPERATION

    stations = stations_for_del(routes[index_route])
    station =  select_station(routes[index_route], stations)
    return if station == END_OPERATION

    remove_action(index_route, station)
  end

  def assign_route
    return if (index_route = select_route) == END_OPERATION
    return if (index_train = select_train) == END_OPERATION

    assign_route_action(index_route, index_train)
  rescue StandardError => e
    puts e
    pause
    retry
  end

  def select_train
    if list_trains(trains) == END_OPERATION
      END_OPERATION
    else
      print "Выбирайте поезд (1 - #{trains.size}): "
      choose_item(trains.size)
    end
  end

  def assign_route_action(index_route, index_train)
    trains[index_train].assign_route(routes[index_route])
    puts "Route #{print_route(routes[index_route])} set to the train #{trains[index_train].number}"
    pause
  end

  def move_train
    return if list_trains(trains) == END_OPERATION

    print "Какой поезд будем двигать (1 - #{trains.size}, Выход - 0): "
    train_index = choose_item(trains.size)
    if trains[train_index].route.nil?
      puts "Необходимо задать поезду #{trains[train_index].number} маршрут"
      pause
    else
      movment(train_index)
    end
  end

  def movment(train_index)
    loop do
      puts print_route(trains[train_index].route)
      puts "Текущая станция  -  #{trains[train_index].current_station.name}"
      print 'Двигаем: Вперед - 1, Назад - 2 , Выход - 0 : '
      choice = user_choice(%w[1 2])
      trains[train_index].move_forword if choice == '1'
      trains[train_index].move_back if choice == '2'
      break if choice == '0'
    end
  end

  def coose_stations_verified
    loop do
      station_start = choose_station('начальную')
      station_end = choose_station('конечную')
      puts 'Начальная и конечная станция должны отличаться!' if station_start == station_end
      break if station_start == station_end
    end
    [station_start, station_end]
  end

  def manage_car
    return if (index_train = select_train) == END_OPERATION

    train = trains[index_train]
    loop do
      print 'Добавить вагон - 1, Исключить вагон - 2, Выход - 0 :'
      choice = user_choice(%w[1 2])
      add_car_to_train(train) if choice == '1'
      delete_car_from_train(train) if choice == '2'
      break if choice == '0'
    end
  end

  def select_car(train)
    if list_carriages(train) == END_OPERATION
      END_OPERATION
    else
      print "Choose carriage (1 - #{train.carriages.size}): "
      choose_item(train.carriages.size)
    end
  end

  def manage_train
    return if (index_train = select_train) == END_OPERATION

    train = trains[index_train]
    return if (index_car = select_car(train)) == END_OPERATION

    car = train.carriages[index_car]
    loop do
      print 'Take up - 1, Release - 2, Exit - 0 :'
      choice = user_choice(%w[1 2])
      take_up_seat(car) if choice == '1' && car.instance_of?(CarPass)
      take_up_capacity(car) if choice == '1' && car.instance_of?(CarCargo)
      down_seat(car) if choice == '2' && car.instance_of?(CarPass)
      down_capacity(car) if choice == '2' && car.instance_of?(CarCargo)
      break if choice == '0'
    end
  end

  def take_up_seat(car)
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
    car.take_seat
    puts 'The seat was took up'
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
  end

  def take_up_capacity(car)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy}"
    print 'Input value :'
    volume = gets.chomp.to_f
    car.take_capacity(volume)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy} "
  rescue StandardError => e
    puts "#{e} Error input"
    retry
  end

  def down_seat(car)
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
    car.release_seat
    puts 'The seat was released'
    puts "Free - #{car.seats_free}; Buzy - #{car.seats_busy} "
  end

  def down_capacity(car)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy}"
    print 'Input value :'
    volume = gets.chomp.to_f
    car.release_capacity(volume)
    puts "Free - #{car.capacity_free}; Buzy - #{car.capacity_busy} "
  rescue StandardError => e
    puts "#{e} Error input"
    retry
  end

  def add_car_to_train(train)
    puts print_train(train)
    if train.instance_of?(CargoTrain)
      block = ->(param) { param =~ /^(\d){3,5}(\W(\d){0,2})?$/ ? param.to_f : (raise 'Wrone value!') }
      param = choose_param_car(block)
      train.add_car(CarCargo.new(param))
    end
    if train.instance_of?(PassengerTrain)
      block = -> { param =~ /^\d{1,2}$/ ? param.to_i : (raise 'Wrone value!') }
      param = choose_param_car(block)
      train.add_car(CarPass.new(param))
    end
    print_cars(train)
  end

  def choose_param_car(block)
    print 'Input capacity: '
    param = gets.chomp
    param = block.call(param)
  rescue StandardError => e
    puts  "#{e} Try again!"
    retry
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

  def choose_station(text = '')
    print "Задайте станцию #{text} (1 - #{stations.size}): "
    choose_item(stations.size)
  end

  def choose_type_train
    print 'To choose the type of train (1 - Passenger or 2 - Cargo): '
    user_choice(%w[1 2])
  end

  def list_stations(stations)
    if stations.any?
      puts 'Список станций'
      stations.each.with_index(1) { |station, index| puts "#{index}. - #{station.name}" }
    else
      puts 'Список пуст'
      END_OPERATION
    end
  end

  def list_stations_with_trains
    if stations.any?
      puts 'Список станций'
      block = ->(train) { puts print_train(train) }
      stations.each.with_index(1) do |station, index|
        puts "\n#{index}. <#{station.name}>: "
        station.each_train(block)
      end
    else
      puts 'Список пуст'
      END_OPERATION
    end
  end

  def list_trains(trains)
    if self.trains.any?
      puts 'Список поездов'
      trains.each.with_index(1) { |train, index| puts "#{index}. " + print_train(train) }
    else
      puts 'Список пуст'
      pause
      END_OPERATION
    end
  end

  def list_carriages(train)
    if train.carriages.any?
      puts 'Список вагонов'
      print_cars(train)
    else
      puts 'Список пуст'
      END_OPERATION
    end
  end

  def list_routes(routes)
    if self.routes.any?
      puts 'Список маршрутов'
      routes.each.with_index(1) { |route, index| puts "#{index}.  " + print_route(route) }
    else
      puts 'Empty'
      END_OPERATION
    end
  end

  def list_trains_on_station
    return if list_stations(stations) == END_OPERATION

    print "Make a choice (1 - #{stations.size}): "
    index_station = choose_item(stations.size)
    show_station(index_station) unless index_station == END_OPERATION
  end

  def show_station(index_station)
    if stations[index_station].trains.empty?
      puts 'No trains'
    else
      stations[index_station].trains.each { |train| puts print_train(train) }
    end
  end

  def choose_item(count_items)
    choices = []
    count_items.times { |item| choices << (item + 1).to_s }
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
      if carriage.instance_of?(CarCargo)
        car_tail = " -- free: #{carriage.capacity_free} -- busy: #{carriage.capacity_busy}"
      end
      car_tail = " -- free: #{carriage.seats_free} -- busy: #{carriage.seats_busy}" if carriage.instance_of?(CarPass)
      puts "#{index}. № #{carriage.number} -- #{carriage.class}#{car_tail}"
    end
  end

  def user_choice(items)
    choice = ''
    until items.include?(choice) || choice == '0'
      choice = gets.chomp
      print 'Out of range. Once more :' unless items.include?(choice) || choice == '0'
    end
    choice
  end

  def pause
    print 'Для продолжения нажмите ввод'
    gets
  end
end
