class PassengerTrain < Train
  def type_validation?(carriage)
    raise "Error! Carriage's type is not valid!!!"
    true
  end
end