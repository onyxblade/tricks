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

  def accumulate &p
    Stream.new do |y|
      n = 0
      loop do
        y << (0..n).collect{|n| self[n]}.reduce(&p)
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
p double.first 10
p double.rest(3).select{|x| x>15}.first 5

seq = Stream.new do |y|
  n = 1
  a = 1
  loop do
    y << a * (1.0 / n)
    n = n + 2
    a = -a
  end
end

sum = seq.accumulate{|s,x| s + x}
pi = sum.map{|x| x*4}

p pi.first 10

def eular_transform s
  Stream.new do |y|
    n = 1
    loop do
      s0, s1, s2 = s[n-1], s[n], s[n+1]
      y << s2 - ((s2 - s1) ** 2) / (s0 + -2 * s1 + s2)
      n += 1
    end
  end
end

def accelerate s
  Stream.new do |y|
    loop do
      s = eular_transform s
      y << s.first
    end
  end
end

p (eular_transform pi).first 10

p (accelerate pi).first 10
