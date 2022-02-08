require_relative 'accessors'

class Test
  include Accessors

  attr_accessor_with_history :a, :b, :c
  strong_attr_accessor :box, Array
end

p 'Beging test!!'
test1 = Test.new
p test1.methods
test1.instance_variables

test1.a = 3
p 'test1.a = 3'
p test1.a
p 'test1.a = 6'
test1.a = 6
p test1.a
test1.a = 'test-a'
p "test1.a = 'test-a'"
p test1.a
p "history - #{test1.a_history}"
p "current value a = #{test1.a}"
p
test1.b = [2, 3, 65]
p 'test1.b = [2,3,65]'
p test1.b
test1.b = 6.456
p 'test1.b = 6.456'
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
