class CarCargo
  include Manufacture
  include InstanceCounter

  CAPACITY_FORMAT = /\d{2,5}.?(\d{2})*/

  attr_accessor :capacity_free, :capacity_busy, :capacity
  attr_reader :number

  def initialize(capacity)
    @capacity = capacity
    @capacity_free = capacity
    @capacity_busy = 0
    register_instance
    @number = "CC0#{self.class.instances}"
  end

  def take_capacity(volume)
    raise 'Not enough capacity' if capacity_free < volume

    self.capacity_free -= volume
    self.capacity_busy += volume
  rescue StandardError => e
    puts e
  end

  def release_capacity(volume)
    raise 'Capacity free' if capacity_busy.zero?

    self.capacity_busy <= volume ? self.capacity_free = capacity : self.capacity_free += volume
    self.capacity_busy <= volume ? self.capacity_busy = 0 : self.capacity_busy -= volume
  rescue StandardError => e
    puts e
  end
end
