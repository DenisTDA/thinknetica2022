class PassengerTrain < Train
  def type_validation?(carriage)
    raise "Error! Carriage's type is not valid!!!" if carriage.class != CarPass

    true
  end
end
