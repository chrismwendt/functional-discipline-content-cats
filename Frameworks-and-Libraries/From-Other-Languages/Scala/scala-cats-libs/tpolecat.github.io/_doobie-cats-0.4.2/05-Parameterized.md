---
layout: book
number: 5
title: Parameterized Queries
---

In this chapter we learn how to construct parameterized queries, and introduce the `Composite` typeclass.

### Setting Up

Same as last chapter, so if you're still set up you can skip this section. Otherwise let's set up a `Transactor` and YOLO mode.

```scala
import doobie.imports._
import cats._, cats.data._, cats.implicits._
import fs2.interop.cats._
val xa = DriverManagerTransactor[IOLite](
  "org.postgresql.Driver", "jdbc:postgresql:world", "postgres", ""
)
val y = xa.yolo; import y._
```

We're still playing with the `country` table, shown here for reference.

```sql
CREATE TABLE country (
  code       character(3)  NOT NULL,
  name       text          NOT NULL,
  population integer       NOT NULL,
  gnp        numeric(10,2)
  -- more columns, but we won't use them here
)
```

### Adding a Parameter

Let's set up our Country class and re-run last chapter's query just to review.

```scala
case class Country(code: String, name: String, pop: Int, gnp: Option[Double])
```

```scala
scala> (sql"select code, name, population, gnp from country"
     |   .query[Country].process.take(5).quick.unsafePerformIO)
  Country(AFG,Afghanistan,22720000,Some(5976.0))
  Country(NLD,Netherlands,15864000,Some(371362.0))
  Country(ANT,Netherlands Antilles,217000,Some(1941.0))
  Country(ALB,Albania,3401200,Some(3205.0))
  Country(DZA,Algeria,31471000,Some(49982.0))
```

Still works. Ok.

So let's factor our query into a method and add a parameter that selects only the countries with a population larger than some value the user will provide. We insert the `minPop` argument into our SQL statement as `$minPop`, just as if we were doing string interpolation.

```scala
def biggerThan(minPop: Int) = sql"""
  select code, name, population, gnp
  from country
  where population > $minPop
""".query[Country]
```

And when we run the query ... surprise, it works!

```scala
scala> biggerThan(150000000).quick.unsafePerformIO // Let's see them all
  Country(BRA,Brazil,170115000,Some(776739.0))
  Country(IDN,Indonesia,212107000,Some(84982.0))
  Country(IND,India,1013662000,Some(447114.0))
  Country(CHN,China,1277558000,Some(982268.0))
  Country(PAK,Pakistan,156483000,Some(61289.0))
  Country(USA,United States,278357000,Some(8510700.0))
```

So what's going on? It looks like we're just dropping a string literal into our SQL string, but actually we're constructing a proper parameterized `PreparedStatement`, and the `minProp` value is ultimately set via a call to `setInt` (see "Diving Deeper" below).

**doobie** allows you to interpolate values of any type (and options thereof) with an `Meta` instance, which includes

- any JVM type that has a target mapping defined by the JDBC specification,
- vendor-specific types defined by extension packages,
- custom column types that you define, and
- single-member products (case classes, typically) of any of the above.

We will discuss custom type mappings in a later chapter.

### Multiple Parameters

Multiple parameters work the same way. No surprises here.

```scala
scala> def populationIn(range: Range) = sql"""
     |   select code, name, population, gnp
     |   from country
     |   where population > ${range.min}
     |   and   population < ${range.max}
     | """.query[Country]
populationIn: (range: Range)doobie.util.query.Query0[Country]

scala> populationIn(150000000 to 200000000).quick.unsafePerformIO
  Country(BRA,Brazil,170115000,Some(776739.0))
  Country(PAK,Pakistan,156483000,Some(61289.0))
```

### Dealing with `IN` Clauses

A common irritant when dealing with SQL literals is the desire to inline a *sequence* of arguments into an `IN` clause, but SQL does not support this notion (nor does JDBC do anything to assist). **doobie** supports this via *statement fragments* (see Chapter 8).

```scala
def populationIn(range: Range, codes: NonEmptyList[String]) = {
  val q = fr"""
    select code, name, population, gnp
    from country
    where population > ${range.min}
    and   population < ${range.max}
    and   """ ++ Fragments.in(fr"code", codes) // code IN (...)
  q.query[Country]
}
```

Note that the `IN` clause must be non-empty, so `codes` is a `NonEmptyList`.

Running this query gives us the desired result.

```scala
scala> populationIn(100000000 to 300000000, NonEmptyList.of("USA", "BRA", "PAK", "GBR")).quick.unsafePerformIO
  Country(BRA,Brazil,170115000,Some(776739.0))
  Country(PAK,Pakistan,156483000,Some(61289.0))
  Country(USA,United States,278357000,Some(8510700.0))
```

### Diving Deeper

In the previous chapter's *Diving Deeper* we saw how a query constructed with the `sql` interpolator is just sugar for the `process` constructor defined in the `doobie.hi.connection` module (aliased as `HC`). Here we see that the second parameter, a `PreparedStatementIO` program, is used to set the query parameters. The third parameter specifies a chunking factor; rows are buffered in chunks of the specified size.

```scala
import fs2.Stream

val q = """
  select code, name, population, gnp
  from country
  where population > ?
  and   population < ?
  """

def proc(range: Range): Stream[ConnectionIO, Country] =
  HC.process[Country](q, HPS.set((range.min, range.max)), 512)
```

Which produces the same output.

```scala
scala> proc(150000000 to 200000000).quick.unsafePerformIO
  Country(BRA,Brazil,170115000,Some(776739.0))
  Country(PAK,Pakistan,156483000,Some(61289.0))
```

But how does the `set` constructor work?

When reading a row or setting parameters in the high-level API, we require an instance of `Composite[A]` for the input or output type. It is not immediately obvious when using the `sql` interpolator, but the parameters (each of which require a `Meta` instance, to be discussed in a later chapter) are gathered into an `HList` and treated as a single composite parameter.

`Composite` instances are derived automatically for column types (and options thereof) that have `Meta` instances, and for products of other composites (via `shapeless.ProductTypeclass`). We can summon their instances thus:

```scala
scala> Composite[(String, Boolean)]
res7: doobie.util.composite.Composite[(String, Boolean)] = doobie.util.composite$LowerPriorityComposite$$anon$12@49d89bb8

scala> Composite[Country]
res8: doobie.util.composite.Composite[Country] = doobie.util.composite$LowerPriorityComposite$$anon$12@69a109b6
```

The `set` constructor takes an argument of any type with a `Composite` instance and returns a program that sets the unrolled sequence of values starting at parameter index 1 by default. Some other variations are shown here.

```scala
// Set parameters as (String, Boolean) starting at index 1 (default)
HPS.set(("foo", true))

// Set parameters as (String, Boolean) starting at index 1 (explicit)
HPS.set(1, ("foo", true))

// Set parameters individually
HPS.set(1, "foo") *> HPS.set(2, true)

// Or out of order, who cares?
HPS.set(2, true) *> HPS.set(1, "foo")
```

Using the low level `doobie.free` constructors there is no typeclass-driven type mapping, so each parameter type requires a distinct method, exactly as in the underlying JDBC API. The purpose of the `Meta` typeclass (discussed in a later chapter) is to abstract away these differences.

```scala
FPS.setString(1, "foo") *> FPS.setBoolean(2, true)

```
