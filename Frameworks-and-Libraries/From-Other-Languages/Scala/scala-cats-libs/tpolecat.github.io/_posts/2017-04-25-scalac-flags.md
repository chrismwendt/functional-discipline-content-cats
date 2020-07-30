---
layout: post
title: Recommended Scalac Flags for 2.12
tags: scala
---

[Updated 10-May-2017]

Greetings fellow traveler.

Here's a first stab at a set of `scalacOptions` for Scala 2.12. Let me know what you think … some of these options are new and I don't quite know what they do but they sound good so I included them. I will update this post to reflect further suggestions. Confidence high!

This is current as of **Lightbend Scala 2.12.2** and **Typelevel Scala 4** (see below).

```scala
scalacOptions ++= Seq(
  "-deprecation",                      // Emit warning and location for usages of deprecated APIs.
  "-encoding", "utf-8",                // Specify character encoding used by source files.
  "-explaintypes",                     // Explain type errors in more detail.
  "-feature",                          // Emit warning and location for usages of features that should be imported explicitly.
  "-language:existentials",            // Existential types (besides wildcard types) can be written and inferred
  "-language:experimental.macros",     // Allow macro definition (besides implementation and application)
  "-language:higherKinds",             // Allow higher-kinded types
  "-language:implicitConversions",     // Allow definition of implicit functions called views
  "-unchecked",                        // Enable additional warnings where generated code depends on assumptions.
  "-Xcheckinit",                       // Wrap field accessors to throw an exception on uninitialized access.
  "-Xfatal-warnings",                  // Fail the compilation if there are any warnings.
  "-Xfuture",                          // Turn on future language features.
  "-Xlint:adapted-args",               // Warn if an argument list is modified to match the receiver.
  "-Xlint:by-name-right-associative",  // By-name parameter of right associative operator.
  "-Xlint:constant",                   // Evaluation of a constant arithmetic expression results in an error.
  "-Xlint:delayedinit-select",         // Selecting member of DelayedInit.
  "-Xlint:doc-detached",               // A Scaladoc comment appears to be detached from its element.
  "-Xlint:inaccessible",               // Warn about inaccessible types in method signatures.
  "-Xlint:infer-any",                  // Warn when a type argument is inferred to be `Any`.
  "-Xlint:missing-interpolator",       // A string literal appears to be missing an interpolator id.
  "-Xlint:nullary-override",           // Warn when non-nullary `def f()' overrides nullary `def f'.
  "-Xlint:nullary-unit",               // Warn when nullary methods return Unit.
  "-Xlint:option-implicit",            // Option.apply used implicit view.
  "-Xlint:package-object-classes",     // Class or object defined in package object.
  "-Xlint:poly-implicit-overload",     // Parameterized overloaded implicit methods are not visible as view bounds.
  "-Xlint:private-shadow",             // A private field (or class parameter) shadows a superclass field.
  "-Xlint:stars-align",                // Pattern sequence wildcard must align with sequence component.
  "-Xlint:type-parameter-shadow",      // A local type parameter shadows a type already in scope.
  "-Xlint:unsound-match",              // Pattern match may not be typesafe.
  "-Yno-adapted-args",                 // Do not adapt an argument list (either by inserting () or creating a tuple) to match the receiver.
  "-Ypartial-unification",             // Enable partial unification in type constructor inference
  "-Ywarn-dead-code",                  // Warn when dead code is identified.
  "-Ywarn-extra-implicit",             // Warn when more than one implicit parameter section is defined.
  "-Ywarn-inaccessible",               // Warn about inaccessible types in method signatures.
  "-Ywarn-infer-any",                  // Warn when a type argument is inferred to be `Any`.
  "-Ywarn-nullary-override",           // Warn when non-nullary `def f()' overrides nullary `def f'.
  "-Ywarn-nullary-unit",               // Warn when nullary methods return Unit.
  "-Ywarn-numeric-widen",              // Warn when numerics are widened.
  "-Ywarn-unused:implicits",           // Warn if an implicit parameter is unused.
  "-Ywarn-unused:imports",             // Warn if an import selector is not referenced.
  "-Ywarn-unused:locals",              // Warn if a local definition is unused.
  "-Ywarn-unused:params",              // Warn if a value parameter is unused.
  "-Ywarn-unused:patvars",             // Warn if a variable bound in a pattern is unused.
  "-Ywarn-unused:privates",            // Warn if a private member is unused.
  "-Ywarn-value-discard"               // Warn when non-Unit expression results are unused.
)
```

Note that the REPL can't really cope with `-Ywarn-unused:imports` or `-Xfatal-warnings` so you should turn them off for the console.

```scala
scalacOptions in (Compile, console) --= Seq("-Ywarn-unused:imports", "-Xfatal-warnings")
```

If you're like me and you find that the standard library gets in the way (especially `Predef` implicits) you might consider one of these (you don't need both):

```scala
"-Yno-predef"   // no automatic import of Predef (removes irritating implicits)
"-Yno-imports"  // no automatic imports at all; all symbols must be imported explicitly
```

### Modifications for Typelevel Scala 4

[Typelevel Scala 4](https://github.com/typelevel/scala/blob/typelevel-readme/notes/typelevel-4.md) is **highly** recommended for the following additional options.

```scala
scalacOptions ++ Seq(
  "-Yinduction-heuristics",       // speeds up the compilation of inductive implicit resolution
  "-Ykind-polymorphism",          // type and method definitions with type parameters of arbitrary kinds
  "-Yliteral-types",              // literals can appear in type position
  "-Xstrict-patmat-analysis",     // more accurate reporting of failures of match exhaustivity
  "-Xlint:strict-unsealed-patmat" // warn on inexhaustive matches against unsealed traits
)
```

Typelevel Scala 4 offers a more general solution to the `-Yno-predef` business above. See the `-Ysysdef` and `-Ypredef` options at the link above.
