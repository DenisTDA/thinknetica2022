# require_relative 'manufacture.rb'
# require_relative 'instancecounter.rb'

class Train
  include Manufacture
  include InstanceCounter

  NUMBER_FORMAT = /^([a-z]|\d){3}-?([a-z]|\d){2}$/i

  attr_reader :speed, :carriages, :type, :route, :number

  @@all_trains = {}

  def self.find(number)
    @@all_trains[number]
  end

  def initialize(number)
    @number = number
    validate!
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
    self.speed == 0 && type_validation?(carriage) ? carriages << carriage : (puts 'Состав движется')
  end

  def delete_car(carriage)
    if self.speed == 0
      carriages.size > 0 ? carriages.delete(carriage) : (puts 'Состав уже расформирован')
    else
      puts 'Состав движеться'
    end
  end

  def set_route(route)
    self.route = route
    self.index_station = 0
    self.route.stations[0].receive(self)
  end

  def current_station
    route.stations[@index_station]
  end

  def move_forword
    if last?
      puts "#{current_station.name} - конечная станция следования"
    else
      current_station.send(self)
      self.index_station += 1
      current_station.receive(self)
    end
  end

  def move_back
    if first?
      puts "#{current_station.name} - начальная станция следования"
    else
      current_station.send(self)
      self.index_station -= 1
      current_station.receive(self)
    end
  end

  def next_station
    route.stations[index_station + 1] unless last?
  end

  def previous_station
    route.stations[index_station - 1] unless first?
  end

  def valid?
    validate!
    true
  rescue StandardError => e
    puts "ERROR!!! ==> #{e}"
    false
  end

  def each_carriage(&block)
    carriages.each.with_index(1, &block)
  end

  protected

  attr_accessor :index_station
  attr_writer :route

  def first?
    index_station.zero?
  end

  def last?
    self.index_station == route.stations.size - 1
  end

  def validate!
    raise "Incorrect input of train's number!" if number !~ NUMBER_FORMAT
    raise "#{number} - Train allready exist" if self.class.find(number)
  end

  def type_validation?(carriage); end
end
