require_relative 'seed.rb'
require_relative 'train.rb'
require_relative 'train_pass.rb'
require_relative 'train_cargo.rb'
require_relative 'car_cargo.rb'
require_relative 'car_pass.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'railway.rb'
require_relative 'interface.rb'

rw = RailWay.new 
seed(rw)
menu = Interface.new(rw)
menu.do_list
