---
layout: post
title: "Functional Programming in Java, Kotlin and JavaScript - Part 1: The Power Of Pure Functions"
image: "assets/img/mathematics-1509559_1280.jpg"
feature-img: "assets/img/mathematics-1509559_1280.jpg"
tags: [functional programming, Java, Kotlin, JavaScript]
---

**This is part of a series about developing your skills as a software developer. Most developers today work with a multi paradigm language. You probably started out with imperative and object oriented programming. Those of us with a background in Java or JavaScript have most likely started transitioning to a declarative style after discovering the benefits of lambdas and higher order functions. However what most don't realize is that this is the gateway into functional programming.**

**Why should I learn functional programming?**

What was the appeal of lambdas and higher order functions? You most likely felt that you could write a lot less code without compromising readability, right? By just learning to utilize functions properly you can reap several benefits:

* Simpler code that is easier to reason about.
* Code that is more reliable.
* Code that is easier to test.
* Code that requires less debugging.
* Code that is more reusable.
* Code that can leverage powerful optimizations when needed.

It will also become apparent that most object oriented design patterns can be replaced by just utilizing functions properly.

**What is the minimum needed for functional programming?**

The definition of functional programming lacks a precise answer. But several developers mention first class functions, function purity and referential transparency as the fundamental parts.

**What are first class functions?**

It is a language feature that allows functions to be assigned to variables (preferably constants) or used as arguments to other functions.

**What is function purity?**

Function purity is when a function is deterministic and free from side effects. In other words the same given input should always produce the same expected output. If a function mutates any of it's given arguments, returns a random or other generated value or does operations such as I/O then the function is not considered pure.

**Examples of function purity**

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/function-purity/function-purity.java"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/function-purity/function-purity.kt"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/function-purity/function-purity.js"></script>

**What is referential transparency?**

A function is referentially transparent when it can be replaced with it's value without changing the programs behavior. If the function is not pure then it is called referentially opaque.

**What is so good about referential transparency?**

For this I will quote Wikipedia. "The importance of referential transparency is that it allows the programmer and the compiler to reason about program behavior. This can help in proving correctness, simplifying an algorithm, assisting in modifying code without breaking it, or optimizing code by means of memoization, common subexpression elimination, lazy evaluation, or parallelization." Also see an elaborate answer on Quora, [Why is referential transparency a good idea? - Quora](https://www.quora.com/Why-is-referential-transparency-a-good-idea).

**What is memoization?**

Memoization is a technique to store the result of a computation for a given input. The next time the function is called with the same argument it returns the stored result instead of running the computation again.

**When is memoization useful?**

If you are running expensive computations on data that is recurring. Another use case could be when doing transformations on elements in a list. Using a memoized function for operations such as map or reduce could potentially improve performance.

**Examples of memoization**

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/memoization/memoization.java"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/memoization/memoization.kt"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/memoization/memoization.js"></script>

[//]: # (**What is lazy evaluation?**)

**What more can you do with functions?**

You can also curry, compose and partially apply.

**What is currying?**

Currying is a mathematical transformation of a function with several arguments into a function that takes one argument which returns another function that takes one argument. Once each of these one argument functions have been applied then the last one applied will return the result.
This is the mathematical definition `f:(X x Y) -> Z` which can be curried to `h:X -> (Y -> Z)` where `h(x)(y) = f(x,y)`.

**Currying sounds very mathematical, what practical use does it have?**

Currying on it's own is not very useful. However it let's us leverage partial application and function composition.

**Examples of currying**

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/curry/curry.java"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/curry/curry.kt"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/curry/curry.js"></script>

**What does composition mean in the case of functions?**

Function composition is a mathematical way of chaining functions together. The only requirement is that the functions are unary (single argument). What you get is very similar to the pipe operator in bash. You give the first function some input, that function will produce output which is given as input to the next function etc. until we end up at the last function which will give us the final result. What is notable about compose is that it is right to left base (for mathematical reason). There is usually a left to right version available which is called pipe, depending on your preference.

**When should I use function composition?**

Whenever you have two or more functions that you want to combine to create a more complex function. Another example is when you are calling `map` several times on a collection with different transformations. Instead of calling `map` three times, which will iterate over the entire collection three times (and also create a new instance). You could instead compose the functions to create a new function and call it once using only one `map`.

**Examples of function composition**

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/function-compose/function-compose.java"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/function-compose/function-compose.kt"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/function-compose/function-compose.js"></script>

**What is partial application?**

Partial application is when you apply one argument to a function that takes several arguments. This ties back to currying, what you actually do is apply an argument to the outer function which then returns the next unary function storing the applied argument as a closure. When you apply the last function it will evaluate using all the provided arguments and return the result.

**When is partial application useful?**

It let's you write very generic functions that you can "configure" to make them more specific. This is reusability at it's finest.

**Examples of partial application**

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/partial-application/partial-application.java"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/partial-application/partial-application.kt"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/partial-application/partial-application.js"></script>

**What is pointful/pointfree?**

Pointful is when you call a function explicitly with it's arguments. Pointfree is when you only reference a function without explicitly stating any arguments. An example of this is a higher order function that takes a function as an argument and implicitly calls it with the expected arguments.

**Why should I prefer pointfree style?**
This is more or less a personal preference, but if you lean more towards eliminating unnecessary code then pointfree is the way to go.

**Examples of pointful/pointfree**

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/pointfree/pointfree.java"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/pointfree/pointfree.kt"></script>

<script src="https://gist-it.appspot.com/https://github.com/chriskevin/programming-idioms/blob/master/pointfree/pointfree.js"></script>

[//]: # (**What is equational reasoning?**)

[//]: # (**Conclusion**)

**Java Resources**

* [Do it in Java 8: Automatic memoization - Pierre-Yves Saumont](https://dzone.com/articles/java-8-automatic-memoization)
* [What's Wrong with Java 8: Currying vs Closures - Pierre-Yves Saumont](https://dzone.com/articles/whats-wrong-java-8-currying-vs)
* [What's Wrong in Java 8, Part II: Functions & Primitives - Pierre-Yves Saumont](https://dzone.com/articles/whats-wrong-java-8-part-ii)
* [What's wrong in Java 8, part VI: Strictness - Pierre-Yves Saumont](https://dzone.com/articles/whats-wrong-java-8-part-vi)
* [How to Create an Immutable Class in Java - Hussein Terek](https://dzone.com/articles/how-to-create-an-immutable-class-in-java)
* [Functional Programming with Java 8 by - Venkat Subramaniam](https://www.youtube.com/watch?v=15X0qFtBqiQ)
* [Vavr](https://www.vavr.io/)
* [Immutables](https://immutables.github.io/)

**Kotlin Resources**

* [Arrow](https://arrow-kt.io/)

**JavaScript Resources**

* [Professor Frisby's Mostly Adequate Guide to Functional Programming](https://drboolean.gitbooks.io/mostly-adequate-guide-old/content/)