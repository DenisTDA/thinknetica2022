
class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def insert(station)
    @stations.include?(station) ? (puts "<#{station.name}> Уже в маршруте") : @stations.insert(-2, station) 
  end

  def remove(station)
    if @stations.first == station || @stations.last == station
      puts "Станций для удаления нет"
    else
      @stations.delete(station) {"Станция отсутствует в маршруте"} 
    end
  end
end