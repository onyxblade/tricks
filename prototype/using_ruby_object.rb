class Object

  def [] (name)
    var = instance_variable_get("@#{name}") || @prototype && @prototype[name]
    if var.class == Proc
      lambda{ |*arg| instance_exec(*arg, &var) }
    else
      var
    end
  end

  def []= (name, value)
    instance_variable_set("@#{name}", value)
  end

  def method_missing(name, value=nil)
    if name[-1] == '='
      self[name[0...-1]]= value
    else
      self[name]
    end
  end

end


class Proc
  def construct *arg
    obj = Object.new
    obj.instance_exec(*arg ,&self)
    obj
  end

end

a = lambda {
  self.a = 1
  self.c = 3
}.construct 
a.fun = lambda { self.a += 1 }
p a.a # => 1

b = Object.new
b.prototype = a
b.fun.call 
p b.a # => 2

c = Object.new
c.prototype = b
c.fun.call
p c.a # => 3
p c.c # => 3
p c.instance_variables # => [:@a, :@prototype]