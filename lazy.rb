class Stream
  def initialize &p
    @enumerator = Enumerator.new &p
    @evaluated = 0
    @values = []
  end

  def [] n
    if n >= @evaluated
      (@evaluated..n).each do |n|
        @evaluated += 1
        @values[n] = @enumerator.next
      end
    end
    @values[n]
  end

  def first n = 1
    n == 1 ? self[0] : (0..n-1).map{|i| self[i]}
  end

  def rest n = 1
    Stream.new do |y|
      loop do
        y << self[n]
        n += 1
      end
    end
  end

  def map &p
    Stream.new do |y|
      n = 0
      loop do
        y << p.call(self[n])
        n += 1
      end
    end
  end

  def select &p
    Stream.new do |y|
      n = 0
      loop do
        y << self[n] if p.call(self[n])
        n += 1
      end
    end
  end

  def self.map *s, &p
    Stream.new do |y|
      n = 0
      loop do
        y << p.call(s.collect{|x| x[n]})
        n += 1
      end
    end
  end

end

integers = Stream.new do |y|
  n = 1
  loop {
    y << n
    n += 1
  }
end

double = Stream.map(integers,integers.rest){|v1,v2| v1 + v2}
double[10]
p double.first 10
p double.rest(3).select{|x| x>15}.first 5
