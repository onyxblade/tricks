
class HookedArray < Array 
  
  @unhook_methods = [:each, :collect] 
  @unhook_methods = Hash[@unhook_methods.collect{|x| [x, Array.instance_method(x)]}]

  def before_hook
    puts 'before'
  end

  def after_hook
    puts 'after'
  end

  @unhook_methods.each do |k, v|
    define_method(k) do |*arr, &block|
      before_hook
      v.bind(self).call(*arr, &block)
      after_hook
    end
  end

end

a = HookedArray.new(4,2)
a.collect{|x| x}
