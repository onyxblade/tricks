require 'fiddle'
require 'fiddle/import'

module Lib
  extend Fiddle::Importer
  dlload './hw.so'
  extern 'int hw(char*, int)'
  extern 'void hw_s(*)'

  Struct_Test = struct 'char* string, int integer'
end

a = Lib.hw("Hello World.", 9)   #=> 打印 Hello World.
a   #=>9

s = Lib::Struct_Test.malloc
s.string = "test"
Lib.hw_s(s)
s.integer   #=>1000
s.string.to_s   #=>rest
Fiddle.free(s.to_i)