require 'method_source'

# 科学的Fiber
class ScientificFiber

  def initialize env, &block
    @sections = block.source.split("\n")[1..-2].join.split('yield')
    @env = env
    @current = 0
  end

  def resume
    return false if @current >= @sections.size
    @env.eval @sections[@current]
    @current += 1
  end

  def marshal_dump
    [@sections, @current]
  end

  def marshal_load array
    @sections, @current = array
  end

  def bind env
    @env = env
    self
  end
end

class EvalEnv
  def initialize params={}
    params.each{|k,v| define_singleton_method(k){v}}
  end

  def eval expr
    instance_eval expr
  end
end

env = EvalEnv.new a:1, b:2

sf = ScientificFiber.new env do
  p a
  yield
  p b
end

sf.resume
sf = Marshal.load(Marshal.dump(sf)).bind(env)
sf.resume