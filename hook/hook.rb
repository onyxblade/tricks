
class HookedArray < Array 
  
  @unhook_methods = %i{<< []= clear collect! compact! concat delete delete_at delete_if fill flatten! replace insert keep_if map map! pop push reject! replace rotate! select! shift shuffle! slice! sort! sort_by! uniq! unshift}
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
      result = v.bind(self).call(*arr, &block)
      after_hook
      result
    end
  end

end

class HookedString < String
  @unhook_methods = %i{<< []= capitalize! chomp! chop! clear concat delete! downcase! encode! force_encoding gsub! insert lstrip! succ! next! prepend replace reverse! rstrip! slice! squeeze! strip! sub! swapcase! tr! tr_s! upcase!}
  @unhook_methods = Hash[@unhook_methods.collect{|x| [x, String.instance_method(x)]}]

  def before_hook
    puts 'before'
  end

  def after_hook
    puts 'after'
  end

  @unhook_methods.each do |k, v|
    define_method(k) do |*arr, &block|
      before_hook
      result = v.bind(self).call(*arr, &block)
      after_hook
      result
    end
  end

end

a = HookedArray.new([1,2,3])
a.collect!{|x| p x}

s = HookedString.new("test")
s.capitalize!