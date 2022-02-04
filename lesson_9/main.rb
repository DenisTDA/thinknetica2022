require_relative 'manufacture'
require_relative 'instancecounter'
require_relative 'train'
require_relative 'train_pass'
require_relative 'train_cargo'
require_relative 'car_cargo'
require_relative 'car_pass'
require_relative 'station'
require_relative 'route'
require_relative 'railway'
require_relative 'seed'

rw = RailWay.new
seed(rw)
rw.do_list
