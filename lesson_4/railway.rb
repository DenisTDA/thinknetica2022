class RailWay
  #По хорошему надо attr_accessor  переместить в protect, но для seed оставил здесь. 
  attr_accessor :routes, :trains, :stations  
  
  def initialize()
    @stations = []
    @trains = []
    @routes = []
  end
   
  def create_station(station_title)
    self.stations << Station.new(station_title)
  end

  def create_train(number, type)
    if type == PassengerTrain then self.trains << PassengerTrain.new(number) end
    if type == CargoTrain then self.trains << CargoTrain.new(number) end
  end

  def create_route(station_start, station_end)
    self.routes << Route.new(self.stations[station_start], self.stations[station_end])
   end

  def set_route_to_train(train_index, route_index)
    self.trains[train_index].set_route(self.routes[route_index])
  end

  def list_stations
    puts "Список станций"
    if self.stations.any? 
      self.stations.each_index {|index| puts "#{index + 1} - #{self.stations[index].name}"} 
    else
      puts "Список пуст"
    end
  end

  def list_trains
    puts "Список поездов"
    if self.trains.any?
      self.trains.each_index do |index| 
        train = self.trains[index]
        puts "#{index + 1} - " + print_train(train) 
      end
    else
      puts "Список пуст"
    end
  end
  
  def list_routes
    puts "Список маршрутов"
    if self.routes.any?
      self.routes.each.with_index(1) {|route, index| puts "#{index}.  " + print_route(route)} 
    else
      puts "Список пуст"
    end
  end

  def list_trains_on_station(index_station)
    if self.trains.empty? 
      (puts "Поезда еще не созданы") 
    elsif  self.stations[index_station].trains.empty? 
      puts "На станции нет поездов"
    else
      self.stations[index_station].trains.each {|train| puts print_train(train)}
    end
  end


  def add_station_to_route(index_route, index_station)
    self.routes[index_route].insert(self.stations[index_station])
  end
  
  def del_station_from_route(index_route, index_station)
    self.routes[index_route].remove(self.routes[index_route].stations[index_station])
  end

  def add_car_to_train (train)
    puts train.number
    train.add_car(CarCargo.new()) if train.class == CargoTrain 
    train.add_car(CarPass.new()) if train.class == PassengerTrain
    print_cars(train)
  end
    
  def delete_car_from_train(train)
    puts train.number
    print_cars(train)
    begin
      print "Какой вагон отцепляем? (1 - #{train.carriages.size}): "
      index = validation_input(1..train.carriages.size)
      car_index = index.to_i - 1
      train.delete_car(train.carriages[car_index]) 
    end until index == '0'
    print_cars(train)
  end

  def print_route(route)
    route_chain = ''
    route.stations.each.with_index do |station, index|
      index.zero? ? route_chain = "<#{station.name}>" : route_chain+= " -- <#{station.name}>"
    end
    route_chain
  end

  def print_cars(train)
    train.carriages.each.with_index(1) {|car, index| puts "#{index}. #{car}"}
  end
 
  protected  
  def pause
    print "Для продолжения нажмите ввод"
    gets
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

  def print_train(train)
    train_info = "#{train.number} -- #{train.class}"
    train_info += " -- #{train.carriages.size}" if train.carriages.any?
    train_info += " -- #{print_route(train.route)}" unless train.route.nil?
    train_info
  end
end