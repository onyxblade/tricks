require './macro'

RubyMacro.apply do
  define :CATS, 2
end

puts CATS # => 2
puts self # => main
