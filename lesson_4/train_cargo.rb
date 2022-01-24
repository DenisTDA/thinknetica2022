class CargoTrain < Train
  protected
  def type_validation!(carriage)
    carriage.class == CarCargo
  end
end