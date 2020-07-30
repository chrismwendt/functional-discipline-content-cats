---
layout: post
title: "Design Patterns"
image: "assets/img/background-3048876_1280.jpg"
feature-img: "assets/img/background-3048876_1280.jpg"
tags: [design patterns, programming, software entropy]
---

**This is part of a series about developing your skills as a software developer. We are all facing the problem of software entropy and would like to reuse code as much as possible. Back in 1995 the book Design Patterns by Erich Gamma, John Vlissides, Ralph Johnson och Richard Helm was published, as a first step towards more reusable code.**

**What are design patterns?**

Design patterns are general, reusable solutions to common problems in a given context. [Software Design Patterns - Wikipedia](https://en.wikipedia.org/wiki/Software_design_pattern)

**Do we need design patterns?**

It depends on several factors. The context of the specific problem, the capabilities of the programming language and what programming paradigm you follow. Without taking all of these things into consideration a design pattern could potentially introduce more complexity.

**What types of patterns are there?**

Creational, structural and behavioral.

**Can you apply a design pattern to any language or paradigm?**

If you are using a multi-paradigm language then it is probably possible to implement all or at least most of them. However as implied earlier, whether you need them is up to the features of the programming language and paradigm. Most of the patterns (GOF) where based on imperative and object oriented programming. A purely functional language would solve it using functional idioms that are baked into the language.

**What is an idiom?**

An idiom is also a reoccuring pattern, but usually smaller than a software design pattern. An imperative idiom would be for example a for loop, while functional idioms are higher order functions, currying or function composition, to name a few.

**Are there any better alternatives than the GOF patterns?**

As has been pointed out, most of the design patterns are not useful in a purely functional language. Peter Norvig made a comparison in 1996 where 16 out of the 32 patterns were not necessary by utilising features in dynamic languages (Lisp, Dylan), see [Design Patterns in Dynamic Languages](http://www.norvig.com/design-patterns/). The same stands true in multi-paradigm languages that are functional like, it is usually more practical to use a functional idiom before a design pattern. Venkat Subramaniam shows some examples of this in one of his Java talks [Design Patterns in the Light of Lambda Expressions](https://www.youtube.com/watch?v=e4MT_OguDKg).

**Conclusion**

While the idea of having reusable design patterns is nice, they have not been updated much since they were conceived in 1995. Also they were based heavily on the software industry at the time that was heavily dominated by object oriented programming. Since then a lot of issues have been pointed out when it comes to object oriented programming. Functional programming has meanwhile reemerged and increased in popularity. Where a lot of the new features that are added to the existing leading languages have origins in purely functional languages.

Based on these observations I think that it would be interesting to follow up with an article about "OOP vs. FP" as well as "Design Patterns vs. Functional Idioms". Where we compare the design pattern implementation in several popular languages against the functional alternative, if applicative to said languages.