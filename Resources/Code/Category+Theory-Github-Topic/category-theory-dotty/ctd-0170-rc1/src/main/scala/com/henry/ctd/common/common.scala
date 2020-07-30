package com.henry.ctd.common

val identity = [A] => a: A => a
def absurd[A]: Nothing => A = ???
val unit = [A] => _: A => ()
val yes = [A] => _: A => true
val no = [A] => _: A => false