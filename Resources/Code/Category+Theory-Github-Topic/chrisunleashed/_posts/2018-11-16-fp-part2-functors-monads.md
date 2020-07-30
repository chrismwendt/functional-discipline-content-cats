---
layout: post
title: "Functional Programming - Part 2: Semi Groups, Monoids, Functors and Monads"
image: "assets/img/mathematics-1509559_1280.jpg"
feature-img: "assets/img/mathematics-1509559_1280.jpg"
tags: [functional programming, Java, JavaScript]
---

**This is part of a series about developing your skills as a software developer. Last time when we talked about functional programming we only touched [the basics](https://chriskevin.github.io/chrisunleashed/2018/09/28/fp-part1-java-kotlin-js.html). Beyond this point we start heading down the rabbit hole, which in this case goes very deep. All the way down to Category Theory. Now programming and mathematics start to get interrelated. However in this article we will try to stay more close to the practical applications in programming and leave the advanced math for a later time.**

**What is Category Theory?**

Prof Frisby gives this simplified explanation, "Category theory is an abstract branch of mathematics that can formalize concepts from several different branches such as set theory, type theory, group theory, logic, and more. It primarily deals with objects, morphisms, and transformations, which mirrors programming quite closely.", [Prof. Frisby Ch.05 - Coding by Composition](https://mostly-adequate.gitbooks.io/mostly-adequate-guide/ch05.html#category-theory). In reality it is a bit more complex than that, but delving deeper right now will not do us much good. However there are some basic math that we need to look at to make more sense of **Semi Groups**, **Monoids**, **Functors** and **Monads**. The concepts that are of interest to us are **associativity**, **commutativity** and **identity**.

**What is associativity?**

Associativity can be represented by a simple addition ```(x + y) + z = x + (y + z) = x + y + z```. Where grouping and applying an operator produces the same result as apply them separately in sequence.

**What is commutativity?**

Commutativity is the same as associativity but the order does not affect the result. ```x + y = y + x```.

**What is identity?**

Identity is when you combine a binary operator (e.g. + or ·) with a [neutral element](https://en.wikipedia.org/wiki/Identity_element) (e.g. 0 for addition or 1 for multiplication). ```x + 0 = x or x · 1 = x```

**What is composition?**

We talked about composition last time but it is good to do a quick repetition here as well. ```(f ∘ g)(x) = g(f(x))```

**What is a Semi Group?**

Now what is this semi group thing? Simply put it is a type that has a `concat` method and is associative. [Prof. Frisby gives a good detailed explanation of Semi Groups](https://egghead.io/lessons/javascript-combining-things-with-semigroups). While most of us have never though about it we have actually used semi groups several times. Both String and a List are semi groups since both of these can be concatenated and are associative.

**What is a Monoid?**

A monoid is a semi group which also has a neutral element. So String is not just a semi group but also a monoid since it has `""` as a neutral element and the same thing goes for List which has `[]`. Other monoids are addition and multiplication.

**What is the point of knowing about Semi Groups and Monoids?**

They tell us additional details about our computations. If we know something is a semi group then we also know that there is an unsafe (breaking) computation that we also need to handle while on the other hand the monoid can guarantee us a value since it has it's neutral element (empty value).

**What is a Functor?**

A much simplified explanation of a functor is a type that is a container of a value. This container type has an interface which is the `.map` method which takes a function as an argument. In practice what you do is put a value inside of the container type and then you tell it to transform the containing value by passing a function to the `map` method. This will return a new instance of the same container type but with the new value.

```
A psuedo code example of a functor.

container = Container.of(123) // Container(123)

container.map(x -> x * 2) // Container(246)
```

**What are Functors useful for?**

The previous example was of the most basic type of functor called the **Identity** functor. This is related to the identity function and identity property, but all of that is outside of scope for this article. What is more interesting is that there are other types of functors and every functor has an internal context. Take for example the `List` functor which holds a list of values. When calling `map` it will internally iterate through the list of values that it holds. This is where it starts to get very powerful, from the outside you just call the same `map` method with any generic function and it just works. The functor abstracts away all the tedious details.

```
Another pseudo code example of functors.

list = List.of(1, 2, 3) // List(1, 2, 3)

list.map(x -> x * 2) // List(2, 4, 6)

Externally they look the same, but interally the the functor handles the application of the function differently in relation to the functors internal context.
```

**What is a Monad?**

Just like the explanation of what a functor is, this is also going to be a bit over simplified. But to keep it understandable you can say that a monad is a functor with an additional `.of` method which is more or less a factory method and a chain/join/bind (depending on programming language) method is a monad. The join function is used for flattening monads when they become nested e.g. `Monad(Monad(value))`. There are also three laws that they need to follow to truly be monads, associativity, right identity and left identity. (I will provide an update later where I explain these laws properly).

```
Pseudo example of a monad.

monad = Monad.of(1) // Monad(1)

monad.map(x -> x + 1) // Monad(2)
monad.map(someFunctionReturningAMonad) // Monad(Monad(1))

nestedMonad.chain(someFunctionReturningAMonad) // Monad(1)
```

**What are Monads useful for?**
Like functors, monads are very versatile since they all expose the same simple interface through `map` but internally the can solve different problems. One of these is the **Maybe/Optional** monad. Internally it handles whether a value exists or not. When calling `map` it will check if it has a value, if it does it will apply the provided function otherwise ignore it. This allows you to build up a computation of things that should happen given that the value exists. It is first at the end that you will need to consider what to do if the value does not exist. Either you return the Maybe or you handle it at the end of your mapping chain. This produces very clean code and you eliminate the need of indenting and nesting that if/else statements create. A some monads are also sum types. Other notable monads are Either that returns one of two possible values (values can be of different types), **Try** that handles success or failure cases, **IO/Task/Future** that handle execution of code that have side effects or are asynchronous.

**What is a Sum type?**

The Maybe monad is usually implemented as a sum type where the sum is a **Just/Some** and a **Nothing** type. The Just will apply functions when `map` is called while Nothing will instead ignore it. It is also the Just that is the only one that actually contains a value.

**Conclusion**

When you model your program based on mathematical concepts you reap several benefits. You reduce the amount of code and keep it DRY by reusing powerful abstract data types (semi groups, monoids, monads, etc.). The underlying mathematical laws gives you a solid framework which allows you to reason about your program in a better way. You can prevent and detect problems easier, simplify and optimise by relying on the deterministic properties of said laws.

**General**

* [A monad is just a monoid in the category of endofunctors, what's the probleⅿ? - Stack Overflow](https://stackoverflow.com/questions/3870088/a-monad-is-just-a-monoid-in-the-category-of-endofunctors-whats-the-proble%E2%85%BF)
* [Tackling the awkward squad: monadic input/output, concurrency, exceptions, and foreign-language calls in Haskell - Microsoft Research](https://www.microsoft.com/en-us/research/publication/tackling-awkward-squad-monadic-inputoutput-concurrency-exceptions-foreign-language-calls-haskell/)
* [Fantas, Eel, and Specification 2: Type Signatures · Tom Harding](http://www.tomharding.mAe/2017/03/08/fantas-eel-and-specification-2/)
* [Monads are hard because ... - John D. Cook](https://www.johndcook.com/blog/2014/03/03/monads-are-hard-because/)
* [Why Do Monads Matter? - Chris Smith](https://cdsmith.wordpress.com/2012/04/18/why-do-monads-matter/)

**Java**

* [Introduction to Vavr’s Either - Baeldung](https://www.baeldung.com/vavr-either)
* [Guide to Try in Vavr - Baeldung](https://www.baeldung.com/vavr-try)
* [Introduction to Future in Vavr - Baeldung](https://www.baeldung.com/vavr-future)
* [How Optional Breaks the Monad Laws and Why It Matters - Marcello La Rocca](https://www.sitepoint.com/how-optional-breaks-the-monad-laws-and-why-it-matters/)
* [Vavr](http://www.vavr.io/)

**JavaScript**

* [Professor Frisby's Mostly Adequate Guide to Functional Programming](https://mostly-adequate.gitbooks.io/mostly-adequate-guide/)
* [Professor Frisby Introduces Composable Functional JavaScript](https://egghead.io/courses/professor-frisby-introduces-composable-functional-javascript)
* [Extensible Effects in Node.js, Part 1 - HumbleSpark](https://www.humblespark.com/blog/extensible-effects-in-node-part-1)
* [Javascript Functor, Applicative, Monads in pictures – Medium](https://medium.com/@tzehsiang/javascript-functor-applicative-monads-in-pictures-b567c6415221)
* [The Observable disguised as an IO Monad – Luis Atencio – Medium](https://medium.com/@luijar/the-observable-disguised-as-an-io-monad-c89042aa8f31)
* [Fantasy Land Specification](https://github.com/fantasyland/fantasy-land)
* [Folktale 2.0](https://folktale.origamitower.com/docs/v2.0.0/)

**F#**

* [Monoids without tears | F# for fun and profit](https://fsharpforfunandprofit.com/posts/monoids-without-tears/)
* [Railway Oriented Programming | F# for fun and profit](https://fsharpforfunandprofit.com/rop/)