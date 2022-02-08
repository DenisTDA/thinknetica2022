class CargoTrain < Train
  include Validation

  validate :number, :format, NUMBER_FORMAT
  validate :number, :presence

  def initialize(number)
    super
    validate!
  end

  def type_validation?(carriage)
    raise "Error! Carriage's type is not valid!!!" if carriage.class != CarCargo

    true
  end
end
