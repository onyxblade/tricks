require 'fiddle'
require 'fiddle/import'
require 'benchmark'

module Lib
  extend Fiddle::Importer
  dlload 'sort.so'
  extern 'void merge_sort(int[], int)'
end

def sort_by_c(arr)
  pack = arr.pack('l' * arr.size)
  Lib.merge_sort(pack, arr.size)
  pack.unpack('l' * arr.size)
end

def sort_by_ruby(arr)
  arr.sort_by{|x| x}
end

a = (1..10000000).to_a.shuffle

p Benchmark.realtime{ sort_by_c(a.dup) } #=> 5.959973 其中pack及unpack可用去 2.364577
p Benchmark.realtime{ sort_by_ruby(a.dup) } #=> 24.802533