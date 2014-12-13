life = Life.new
until life.dead?
  plan = Plan.new
  puts 'I Got A New Plan!'
  until plan.succeed?
    idea = Idea.new
    puts 'What About This?'
    plan.instance_eval idea
    if not plan.succeed?
      puts 'Come On!'
    end
  end
  puts "What A Beautiful Day!"
end
puts 'No Regrets.'

#生命是一段漫长的旅程。
#想了，就去做。
#输了，从头再来。
#摔了，爬起来继续。
#赢了，还要再往前走。
#死了，没留下任何遗憾。
