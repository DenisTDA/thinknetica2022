require_relative 'accessors'

class Test
  include Accessors

  attr_accessor_with_history :a, :b, :c
  strong_attr_accessor :box, Array
end

p 'Beging test!!'
test1 = Test.new
test2 = Test.new
p '--------------------------------------'
p test1.methods
test1.instance_variables
p '--------------------------------------'
p test2.methods
test2.instance_variables

p '-------------------------------------'
test1.a = 3
p 'test1.a = 3'
p test1.a
p 'test1.a = 6'
test1.a = 6
p test1.a
test1.a = 'test1-a'
p "test1.a = 'test1-a'"
p test1.a
p "history test1.a_history- #{test1.a_history}"
p "current value test1.a = #{test1.a}"
p '-----------------------------------------------'

test2.a = 5
p 'test1.a = 5'
p test2.a
p 'test1.a = 66'
test2.a = 66
p test2.a
test2.a = 'test2-a'
p "test2.a = 'test2-a'"
p test2.a
p "history test1.a_history- #{test1.a_history}"
p "history test2.a_history- #{test2.a_history}"
p "current value test1.a = #{test1.a}"
p "current value test2.a = #{test2.a}"

p '--------------------------------------------------------'
p
test1.b = %w[ttt www rrr uuu]
p 'test1.b = %w(ttt www rrr uuu)'
p test1.b
test1.b = 99.111
p 'test1.b = 99.111'
p test1.b
test1.b = nil
p 'test1.b = nil'
p test1.b
test1.b = { mask: 'dark' }
p "test1.b = {mask: 'dark'}"
p test1.b
test1.b = 'test-b'
p "test1.b = 'test-b'"
p test1.b
p "history - #{test1.b_history}"
p "current value b = #{test1.b}"
p '-----------------------------------------------------'
test2.b = [2, 3, 65]
p 'test2.b = [2,3,65]'
p test2.b
test2.b = 6.456
p 'test2.b = 6.456'
p test2.b
test2.b = { a: 3, s: { f: 'dfsf' }, j: [1, 3, 4, 5] }
p "test2.b = {a: 3, s: {f: 'dfsf'}, j: [1,3,4,5]}"
p test2.b
test1.b = [[1, 2], [3, 4], [3, 9]]
p 'test2.b = [[1,2], [3,4], [3,9]]'
p test2.b
test2.b = 'test2-b'
p "test2.b = 'test2-b'"
p test2.b
p "history test1.b_history- #{test1.b_history}"
p "history test2.b_history- #{test2.b_history}"
p "current value test1.b = #{test1.b}"
p "current value test2.b = #{test2.b}"

p '-----------------------------------------------------'
p 'test of strong_attr_accesor with Array'

test1.box = [3, 5, 8]
p 'test1.box = [3,5,8]'
p test1.box

begin
  p "test1.box = 'mistake'"
  test1.box = 'mistake'
rescue StandardError => e
  puts e
ensure
  p test1.box
  gets
end
p 'End of test'
