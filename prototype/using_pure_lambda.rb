#每个对象闭包内用一个variables hash存储变量，向外暴露一个handler lambda，handler可接受两个参数，一个参数的时候是get，两个参数的时候是set。

new_object =  lambda { |constructor = nil|
                variables = {:prototype => nil}
  
                pack_lambda = lambda { |lam, handler|   # 将属性中的lambda打包成一个可运行的lambda，并使其中this指向自身
                                $handling = handler     # 用全局变量跨作用域传送handler
                                eval "define_method(:this){$handling}", lam.binding
                                lambda { |*arg| 
                                  result = lam.call(*arg)
                                  $handling = nil       # lambda执行完毕，将用过的全局变量及this置空
                                  result
                                }
                              }
  
                handler = lambda { |name, value=nil|
                            name = name.to_sym if name.respond_to? :to_sym
                            return variables if name == :variables
                            if value.nil?
                              var = variables[name] || variables[:prototype] && variables[:prototype][name] # 沿原型链搜寻变量
                              if var.class == Proc
                                pack_lambda.(var, handler)
                              else
                                var 
                              end
                            else
                              variables[name] = value
                              if value.class == Proc
                                pack_lambda.(variables[name], handler)
                              else
                                variables[name]
                              end
                            end
                          }
                
                pack_lambda.(constructor, handler).call unless constructor.nil? # 若存在构造器则执行
                handler
              }

a = new_object.call( lambda{ this[:a, 1]; this[:c, 3] })
a[:fun, lambda{ this[:a, this[:a]+1] }]
p a[:a]   # => 1

b = new_object.call
b[:prototype, a]
b[:fun].call
p b[:a]   # => 2

c = new_object.call
c[:prototype, b]
c[:fun].call
p c[:a]   # => 3
p c[:c]   # => 3
p c[:variables]  # => {:prototype=>#<Proc:0x2692560@D:/code/tricks/r.rb:16 (lambda)>, :a=>3}