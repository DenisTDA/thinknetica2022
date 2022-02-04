class CarPass
  include Manufacture
  include InstanceCounter

  SEATS_FORMAT = /\d{1,2}/

  attr_accessor :seats_free, :seats_busy, :seats
  attr_reader :number

  def initialize(seats)
    @seats = seats
    @seats_free = seats
    @seats_busy = 0
    register_instance
    @number = "CP0#{self.class.instances}"
  end

  def take_seat
    raise 'No free seats' if seats_free == 0

    self.seats_free -= 1
    self.seats_busy += 1
  rescue StandardError => e
    puts e
  end

  def release_seat
    raise 'No occupied seats' if seats_busy == 0

    self.seats_free += 1
    self.seats_busy -= 1
  rescue StandardError => e
    puts e
  end
end
