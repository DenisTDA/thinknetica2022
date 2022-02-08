# Класс Station (Станция):
#   Имеет название, которое указывается при ее создании
#   Может принимать поезда (по одному за раз)
#   Может возвращать список всех поездов на станции, находящиеся в текущий момент
#   Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых,
#   пассажирских
#   Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов,
#   находящихся на станции).
class Station
  include InstanceCounter
  include Validation

  FORMAT_NAME = /([a-zа-я]|\d){3,}/i

  validate :name, :format, FORMAT_NAME
  validate :name, :presence

  attr_reader :name, :trains

  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @@all_stations << self
    @trains = []
    validate!
    register_instance
  end

  def receive(train)
    trains << train
  end

  def count_type(type)
    trains.count { |train| train.type == type }
  end

  def send_out(train)
    trains.delete(train)
  end

  def each_train(block)
    trains.each do |train|
      block.call(train)
    end
  end
end
