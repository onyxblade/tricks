#可以用于单文件程序的宏，require的话，在eval之后没办法终止原代码的执行
#也可以自制一个require，把源文件的code读进来处理完再eval，但是这样$0之类的就失效了

class RubyMacro
  def self.init outer
    @@binding = outer
  end

  def self.apply &p
    @@gsub = {}
    self.instance_eval &p
    current_file = File.expand_path($PROGRAM_NAME)
    code = File.open(current_file, 'r').read
    code.gsub!(/RubyMacro([\w\W]*?)end/, '')
    @@gsub.each do |k, v|
      code.gsub!(k, v)
    end
    @@binding.eval code
    exit
  end

  def self.define ori, tar
    @@gsub[ori.to_s] = tar.to_s
  end
end

RubyMacro.init binding
