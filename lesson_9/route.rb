class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(start_station, end_station)
    raise 'Stations must be defferent!' if start_station == end_station

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

  def valid?
    validate!
    true
  rescue StandardError => e
    puts e.massege
    false
  end

  protected

  def validate_station_in_route!(station)
    raise 'Error!!!' if stations.include?(station)
  end

  def validate!
    raise 'Error! Type is not valid!' unless stations.all? { |station| station.is_a?(Station) }
  end
end
