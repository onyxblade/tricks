操作调用者上下文

add函数可使调用者所在环境的a增加3。  
使用set_trace_func获得add调用者的binding，然后再在其上下文执行a+=3。