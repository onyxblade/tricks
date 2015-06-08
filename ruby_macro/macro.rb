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
