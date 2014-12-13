ruby模拟js的原型系统
======

目前Object版本对this的模仿还有问题，js里函数对实例变量的操作是使用this进行的，上下文维持原样，而在ruby里我直接把对象的函数用instance_eval执行，改变了上下文环境。

而完全使用lambda的版本没有改变上下文，只是修改了this的指向，应该和js的行为没有差别了。