require 'pp'

class Role
  def initialize(args)
    args.each{ |k,v| self.send("#{k}=", v) }
  end
end

class Skill
  attr_accessor :description
  def apply(origin, target = nil)
    self.description.gsub!("self_", "origin.")
    self.description.gsub!("target_", "target.")
    eval self.description
  end
end

smash = Skill.new
smash.description =<<EOF
  target_hp -= self_str*2
EOF

heal = Skill.new
heal.description =<<EOF
  self_mp -=10
  self_hp +=10
EOF

class Warrior < Role
  attr_accessor :hp, :mp, :str, :skills
end

class Monster < Role
  attr_accessor :hp, :str
end

w = Warrior.new(hp:100, mp:10, str:10, skills:[smash, heal])
m = Monster.new(hp:100, str:30)
heal.apply(w)

pp w

smash.apply(w, m)
pp m