class Route
  include InstanceCounter
  include Validation
  attr_reader :stations

  validate :start_station, :type, Station
  validate :end_station, :type, Station

  def initialize(start_station, end_station)
    raise 'Stations must be defferent!' if start_station == end_station

    @start_station = start_station
    @end_station = end_station
    @stations = [start_station, end_station]
    register_instance
    validate!
  end

  def insert(station)
    raise if [stations.last, stations[-2]].include?(station)

    stations.insert(-2, station)
  end

  def remove(station)
    raise if @stations.size < 3 || !stations.include?(station)

    stations.delete(station)
  end

  protected

  def validate_station_in_route!(station)
    raise 'Error!!!' if stations.include?(station)
  end
end
