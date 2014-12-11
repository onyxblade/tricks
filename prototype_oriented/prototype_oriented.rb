class Object
  
  def [] (name, caller=self)
    v = instance_variable_get("@#{name}")
    return @prototype[name, caller] if v.nil? && !@prototype.nil?
    if v.class == Proc
      lambda{ |*arg| caller.instance_exec(*arg, &v) }
    else
      v
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

a = Object.new
a.a = 1
a.func = lambda { p @a }
a.func.call

b = Object.new
b.prototype = a
b.a = 2
b.func[]

c = lambda {
  self[:a] = 1
  self.b = lambda {}
}.construct
p c
