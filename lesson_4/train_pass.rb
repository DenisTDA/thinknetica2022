require_relative 'train.rb'

class PassengerTrain < Train
  protected
  def type_validation!(carriage)
    carriage.class == CarPass
  end
end