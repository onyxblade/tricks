require 'fiddle'
require 'fiddle/import'

module Lib
  extend Fiddle::Importer
  dlload './hw.so'
  extern 'int hw(int)'
end

a = Lib.hw(3)
p a