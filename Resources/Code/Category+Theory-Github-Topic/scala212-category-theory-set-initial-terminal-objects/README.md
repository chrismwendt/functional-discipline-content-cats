[![Build Status](https://travis-ci.com/mtumilowicz/scala212-category-theory-set-initial-terminal-objects.svg?branch=master)](https://travis-ci.com/mtumilowicz/scala212-category-theory-set-initial-terminal-objects)

# scala212-category-theory-set-initial-terminal-objects
_Reference_: http://eed3si9n.com/herding-cats/initial.html

# definition
Note that category set forms semiring with product and coproduct,
so it makes sens to name some of its objects as **0** and **1**.
Further reading: https://github.com/mtumilowicz/scala212-category-theory-set-semiring

In any category `C`, an object
* **0** is **initial** if for any object `c e C` there
is exactly one isomorphism `0 -> c`
* **1** is **terminal** if for any object `c e C` there
is exactly one isomorphism `c -> 1`

**Remark**: initial (terminal) objects are unique up to isomorphism.

# project description
We will provide implementation of initial and terminal object in
set category.

**In Sets, the empty set is initial and any singleton set is terminal.**

## initial object
We take uninhabited type `Nothing` and we provide implementation
of absurd function (https://hackage.haskell.org/package/void-0.6.1/docs/Data-Void.html).
```
def absurd[A]: Nothing => A = _ => ???
```
* it cannot be called
* it exists
    ```
    val obj = TerminalObjects
    obj.absurd[Int] should not be null
    ```
# terminal object
We take singleton set `Unit`, there can be only one implementation
of function between `Unit` and `A`
```
def unit[A](a: A): Unit = ()
```
```
test("single unit function") {
  val obj = TerminalObjects
  obj.unit(1) should be (obj.unit(2))
}
```