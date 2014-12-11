def add
  exited = nil
  set_trace_func proc{|*e|
    if exited
      eval("a += 3", e[-2])
      set_trace_func nil
    end
    exited = true if e[-3]==:add && e[0]=="return"
  }
end

a = 0
add
p a