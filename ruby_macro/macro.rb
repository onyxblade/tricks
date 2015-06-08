class RubyMacro
  def self.do_not_apply
  end

  def self.apply &p
    @@gsub = {}
    self.instance_eval &p
    current_file = File.expand_path($PROGRAM_NAME)
    code = File.open(current_file, 'r').read
    code.gsub!('RubyMacro.apply', 'RubyMacro.do_not_apply')
    @@gsub.each do |k, v|
      code.gsub!(k, v)
    end
    eval code
    exit
  end

  def self.define ori, tar
    @@gsub[ori] = tar
  end
end
