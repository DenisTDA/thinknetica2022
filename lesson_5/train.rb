
require_relative 'manufacture.rb'
require_relative 'instancecounter.rb'

class Train
  include Manufacture
  include InstanceCounter
  attr_reader :speed, :carriages, :type, :route, :number 
  
  @@all_trains = {}

  def self.find(number)
    @@all_trains[namber] 
  end

  def initialize(number)
    @number = number 
    @speed = 0
    @carriages = []
    @@all_trains[number] = self
    register_instance
  end

  def increase_speed(increment)
    self.speed += increment
  end
  
  def decrease_speed(increment)
    self.speed >= increment ? self.speed -= increment : self.speed = stop!
  end

  def stop!
    self.speed = 0
  end

  def add_car(carriage)
    if type_validation!(carriage) 
      self.speed == 0 ? self.carriages << carriage : (puts "Состав движется")
    else puts "Не прицеплен. Вагон другого типа"
    end
  end
  
  def delete_car(carriage) 
    if self.speed == 0 
      self.carriages.size > 0 ? self.carriages.delete(carriage) : (puts "Состав уже расформирован")
    else
      puts "Состав движеться"
    end
  end

  def set_route(route)
    self.route = route
    self.index_station = 0
    self.route.stations[0].receive(self)  
  end

  def current_station
    self.route.stations[@index_station]
  end

  def move_forword
    unless last?
      current_station.send(self)
      self.index_station += 1
      current_station.receive(self)
    else
      puts "#{current_station.name} - конечная станция следования"
    end
  end

  def move_back
    unless first?
      current_station.send(self)
      self.index_station -= 1 
      current_station.receive(self)
    else
      puts "#{current_station.name} - начальная станция следования"
    end
  end

  def next_station
    self.route.stations[index_station+1] unless last?()
  end

  def previous_station
    self.route.stations[index_station-1] unless first?()
  end

  protected
  attr_accessor :index_station
  attr_writer :route

  def first?
    index_station.zero?
  end

  def last?
    self.index_station == self.route.stations.size() - 1
  end

  def type_validation!()
  end
end

