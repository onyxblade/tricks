The ruby.c one will crash because MRI does not support calling from multiple threads.

The mruby one could work. And we can also run a MRI vm in a single thread, but the forwarding work would be tough.
