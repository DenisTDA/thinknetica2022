=begin
Класс Train (Поезд):
  Имеет номер (произвольная строка) и тип (грузовой, пассажирский) и количество вагонов, 
    эти данные указываются при создании экземпляра класса
  Может набирать скорость
  Может возвращать текущую скорость
  Может тормозить (сбрасывать скорость до нуля)
  Может возвращать количество вагонов
  Может прицеплять/отцеплять вагоны (по одному вагону за операцию, 
    метод просто увеличивает или уменьшает количество вагонов). 
    Прицепка/отцепка вагонов может осуществляться только если поезд не движется.
  Может принимать маршрут следования (объект класса Route). 
  При назначении маршрута поезду, поезд автоматически помещается на первую станцию в маршруте.
  Может перемещаться между станциями, указанными в маршруте. 
    Перемещение возможно вперед и назад, но только на 1 станцию за раз.
  Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
=end
class Train
  attr_reader :speed, :carriages 
  attr_accessor :index_station, :route 
  
  def initialize(number, type, carriages = 0)
    @number, @type, @carriages = number, type, carriages
    @speed = 0
  end

  def increase_speed(increment)
    @speed += increment
  end
  
  def decrease_speed(increment)
    @speed >= increment ? @speed -= increment : @speed = 0
  end

  def add_car() 
    self.speed == 0 ? @carriages+= 1 : (puts "Состав движется")
  end
  
  def delete_car() 
    if self.speed == 0 
      @carriages > 0 ? @carriages-= 1 : (puts "Состав уже расформирован")
    else
      puts "Состав движеться"
    end
  end

  def set_route (route)
    self.route = route
    self.index_station = 0
    @route.stations[0].receive(self)  
  end

  def last?
    self.index_station == @route.stations.size() - 1
  end

  def first?
    index_station.zero?
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
      puts "#{current_station} - конечная станция следования"
    end
  end

  def move_back
    unless first?
      current_station.send(self)
      @index_station -= 1 
      current_station.receive(self)
    else
      puts "#{current_station} - начальная станция следования"
    end
  end

  def next_station
    @route.stations[index_station+1] unless last?()
  end

  def previous_station
    @route.stations[index_station-1] unless first?()
  end
end