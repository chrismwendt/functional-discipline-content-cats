[![Build Status](https://travis-ci.com/mtumilowicz/scala212-category-theory-const-functor.svg?branch=master)](https://travis-ci.com/mtumilowicz/scala212-category-theory-const-functor)

# scala212-category-theory-const-functor

_Reference_: https://bartoszmilewski.com/2015/01/20/functors/

# preliminary
Referring my other github project could be useful 
(basic info concerning functors):
* https://github.com/mtumilowicz/java11-category-theory-optional-is-not-functor

# discussion
When we think about functors we are not at all concerned 
about accessing the values - it's completely outside of 
the formal scope of the functor. Functors are all about
being able to transforming underlying values with functions.

* if there is possibility to access the values - we will
see the transformed result
* if we cannot access them - all we care is that the 
manipulations compose correctly and does not change
anything when composed with identity

# definition
Meaningful example of a functor that does not provide us
with an access to underlying values is a `Const` functor
that completely ignores its second argument:

* `data Const c a = Const c`
* `map :: (a -> b) -> Const c a -> Const c b`
    
**The `Const` data type can be thought of similarly to the const function, 
but as a data type.**

# project description
We will provide simple implementation of `Const` functor in Scala:
```
final case class Const[C, A](param: C) {
  def map[B](f: A => B): Const[C, B] = this.asInstanceOf[Const[C, B]]
}
```
and tests:
* creation
    ```
    val const1: Const[Int, String] = Const(1)
    val const2: Const[Int, Object] = Const(1)
    
    const1.param should be(1)
    const2.param should be(1)
    ```
* equals
    * same values, different dropped type
        ```
        val const1: Const[Int, String] = Const(1)
        val const2: Const[Int, Object] = Const(1)
        
        const1 should be(const2)
        ```
    * different values
        ```
        val const1: Const[Int, String] = Const(1)
        val const2: Const[Int, String] = Const(2)
        
        const1 should not be const2
        ```
    * map
        ```
        val const: Const[Int, Int] = Const(1)
        
        
        val mapped: Const[Int, String] = const.map(_ => "a")
        mapped.param should be(1)
        ```

Note that we provide the simplest implementation that there could be,
follow https://github.com/typelevel/cats/blob/master/core/src/main/scala/cats/data/Const.scala
to see much more sophisticated solution.