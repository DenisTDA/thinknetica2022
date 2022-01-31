=begin
Класс Station (Станция):
  Имеет название, которое указывается при ее создании
  Может принимать поезда (по одному за раз)
  Может возвращать список всех поездов на станции, находящиеся в текущий момент
  Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, 
  пассажирских
  Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, 
  находящихся на станции).
=end
class Station
  include InstanceCounter
  @@all_stations = []

  def self.all
    @@all_stations 
  end
  FORMAT_NAME = /([a-zа-я]|\d){3,}/i
  attr_reader :name, :trains

  def initialize (name)
    @name = name
    puts @name
    @@all_stations << self
    @trains = []
    validate!
    register_instance
  end    

  def receive (train)
    self.trains << train
  end

  def count_type(type)
    self.trains.count {|train| train.type == type}
  end

  def send(train)
    self.trains.delete(train) 
  end
  
  def valid?
    validate!
    true
  rescue => e
    puts "Error!!! ==> #{e.message}"
    false
  end

  protected
  def validate!
    raise "Incorrect entry of station name" if self.name !~ FORMAT_NAME
  end
end