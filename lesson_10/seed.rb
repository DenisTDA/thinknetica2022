def seed(rail)
  21.times { |index| rail.stations << Station.new("Station#{index}") }
  6.times { |index| rail.trains << CargoTrain.new("C00-0#{index}") }
  5.times { |index| rail.trains << PassengerTrain.new("P00-0#{index}") }
  6.times { |index| rail.routes << Route.new(rail.stations[index], rail.stations[-(index + 1)]) }
  5.times { |index| rail.trains[index * 2].assign_route(rail.routes[index]) }

  4.times do |index|
    rand(30..50).times { rail.trains[index].add_car(CarCargo.new(rand(1000..10_000))) }
  end

  (6..9).each do |index|
    rand(20..30).times { rail.trains[index].add_car(CarPass.new(rand(20..60))) }
  end

  puts "\nData has been generated!\nPress Enter"
  gets
end
