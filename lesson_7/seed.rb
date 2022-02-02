def seed (rr)
	st1, st2, st3, st4, st5, st6, st7 = Station.new('Sverdlovsk'.upcase!), Station.new('Moscow'.upcase!), Station.new('Leningrad'.upcase!), Station.new('Omsk'.upcase!), Station.new('Kazan'.upcase!), Station.new('Kirov'.upcase!), Station.new('Ufa'.upcase!)
	tr1, tr2, tr3, tr4 = PassengerTrain.new('11111'), CargoTrain.new('22222'), CargoTrain.new('333-33'), PassengerTrain.new('444-44')
	r1, r2, r3 = Route.new(st1, st5), Route.new(st2, st7), Route.new(st6, st1)

	25.times {tr1.add_car(CarPass.new(40))}   
	41.times {tr2.add_car(CarCargo.new(20000))}   
	63.times {tr3.add_car(CarCargo.new(30000))}
	30.times {tr4.add_car(CarPass.new(38))}      

	tr1.set_route(r1)
	tr2.set_route(r2)
	tr3.set_route(r3)
	tr4.set_route(r2)

	rr.stations = [st1, st2, st3, st4, st5, st6, st7]
	rr.trains = [tr1, tr2, tr3, tr4]
	rr.routes = [r1, r2, r3] 
	rr.trains = [tr1, tr2, tr3, tr4]
end