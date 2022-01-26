
class Train
  attr_reader :speed, :carriages, :type, :route, :number 
  
  def initialize(number)
    @number = number 
    @speed = 0
    @carriages = []
  end

  def increase_speed(increment)
    @speed += increment
  end
  
  def decrease_speed(increment)
    @speed >= increment ? @speed -= increment : @speed = 0
  end

  def add_car(carriage)
    if type_validation!(carriage) 
      self.speed == 0 ? @carriages << carriage : (puts "Состав движется")
    else puts "Не прицеплен. Вагон другого типа"
    end
  end
  
  def delete_car(carriage) 
    if self.speed == 0 
      @carriages.size > 0 ? @carriages.delete(carriage) : (puts "Состав уже расформирован")
    else
      puts "Состав движеться"
    end
  end

  def set_route(route)
    self.route = route
    self.index_station = 0
    @route.stations[0].receive(self)  
  end

  def current_station
    @route.stations[@index_station]
  end

  def move_forword
    unless last?
      current_station.send(self)
      @index_station += 1
      current_station.receive(self)
    else
      puts "#{current_station.name} - конечная станция следования"
    end
  end

  def move_back
    unless first?
      current_station.send(self)
      @index_station -= 1 
      current_station.receive(self)
    else
      puts "#{current_station.name} - начальная станция следования"
    end
  end

  def next_station
    @route.stations[index_station+1] unless last?()
  end

  def previous_station
    @route.stations[index_station-1] unless first?()
  end

  protected
# гетер и сетер  нужны для внутренней логики 
  attr_accessor :index_station
  attr_writer :route

# методы first? и last? для внутренней логики
  def first?
    index_station.zero?
  end

  def last?
    self.index_station == @route.stations.size() - 1
  end

  def type_validation!()
  end
end

