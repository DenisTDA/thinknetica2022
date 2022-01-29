
class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
    register_instance
  end

  def insert(station)
    self.stations.include?(station) ? (puts "<#{station.name}> Уже в маршруте") : self.stations.insert(-2, station) 
  end

  def remove(station)
    if self.stations.first == station || self.stations.last == station
      puts "Станций для удаления нет"
    else
      self.stations.delete(station) {"Станция отсутствует в маршруте"} 
    end
  end
end