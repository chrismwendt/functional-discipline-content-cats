Introduction
============

This library takes its inspiration from category theory and Haskell.  Its goal is to provide a useful set of features that enable programming in a functional style in Python, with category theory as the guiding principles.  If you are new to category theory or don't know Haskell, `Category Theory for Programmers <https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/>`_ by Bartosz Milewski is a great textbook that is immediately useful as a programmer and it covers the basics of Haskell and Category Theory. It also has two sets of video lectures to accompany the text.

The main features of this library are provided by typeclasses and some data types that defines instances of those typeclasses.  A typeclass is like a declaration of an interface for an object.  Their use in this library is to define interfaces for algebraic structures that come from category theory.  There are certain laws that each of those algebraic structures should obey, and the module for each typeclass defines functions that allow you to check whether a data type conforms to those laws.  For examples on how to use those functions, take a look at the tests for `Maybe <https://gitlab.com/danielhones/pycategories/blob/master/tests/test_maybe.py>`_ or `Python builtins <https://gitlab.com/danielhones/pycategories/blob/master/tests/test_builtins.py>`_ in the Pycategories source code.


These are the typeclasses defined in Pycategories:

* `Semigroup <https://en.wikipedia.org/wiki/Semigroup>`_
* `Monoid <https://en.wikipedia.org/wiki/Monoid>`_
* `Functor <https://en.wikipedia.org/wiki/Functor>`_
* `Applicative <https://en.wikipedia.org/wiki/Applicative_functor>`_
* `Monad <https://en.wikipedia.org/wiki/Monad_(category_theory)>`_


These are the data types provided by Pycategories, with the specified typeclass instances defined:

* `Maybe <https://wiki.haskell.org/Maybe>`_
   * Semigroup
   * Monoid
   * Functor
   * Applicative
* `Either <https://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Either.html>`_
   * Functor
   * Applicative
   * Monad
* `Validation <https://hackage.haskell.org/package/validation>`_
   * Semigroup
   * Functor
   * Applicative


And typeclass instances are defined for the following built-in Python types:

* List
   * Semigroup
   * Monoid
   * Functor
   * Applicative
   * Monad
* String
   * Semigroup
   * Monoid
   * Functor
* Tuple
   * Semigroup
   * Monoid
   * Functor
   * Applicative
   * Monad


The behavior of the instances defined for Functor, Applicative, and Monad match the behavior of those definitions in Haskell.  If you need something else for your application, you can redefine the instances for tuple, or define a new product data type that's isomorphic to a tuple.
