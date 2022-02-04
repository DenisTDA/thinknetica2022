def seed(rail)
  st1 = Station.new('Sverdlovsk'.upcase!)
  st2 = Station.new('Moscow'.upcase!)
  st3 = Station.new('Leningrad'.upcase!)
  st4 = Station.new('Omsk'.upcase!)
  st5 = Station.new('Kazan'.upcase!)
  st6 = Station.new('Kirov'.upcase!)
  st7 = Station.new('Ufa'.upcase!)
  tr1 = PassengerTrain.new('11111')
  tr2 = CargoTrain.new('22222')
  tr3 = CargoTrain.new('333-33')
  tr4 = PassengerTrain.new('444-44')
  r1 = Route.new(st1, st5)
  r2 = Route.new(st2, st7)
  r3 = Route.new(st6, st1)

  25.times { tr1.add_car(CarPass.new(40)) }
  41.times { tr2.add_car(CarCargo.new(20_000)) }
  63.times { tr3.add_car(CarCargo.new(30_000)) }
  30.times { tr4.add_car(CarPass.new(38)) }

  tr1.assign_route(r1)
  tr2.assign_route(r2)
  tr3.assign_route(r3)
  tr4.assign_route(r2)

  rail.stations = [st1, st2, st3, st4, st5, st6, st7]
  rail.trains = [tr1, tr2, tr3, tr4]
  rail.routes = [r1, r2, r3]
  rail.trains = [tr1, tr2, tr3, tr4]
end
