---
layout: book
number: 12
title: Custom Mappings
---

In this chapter we learn how to use custom `Meta` instances to map arbitrary data types as single-column values; and how to use custom `Composite` instances to map arbitrary types across multiple columns.

### Setting Up

The examples in this chapter require the `doobie-postgres` add-on, as well as the [argonaut](http://argonaut.io/) JSON library, which you can add to your build thus:

```scala
libraryDependencies += "io.argonaut" %% "argonaut" % "6.2-RC1" // as of date of publication
```

In our REPL we have the same setup as before, plus a few extra imports.

```scala
import argonaut._, Argonaut._
import doobie.imports._
import java.awt.Point
import org.postgresql.util.PGobject
import scala.reflect.runtime.universe.TypeTag
import scala.util.Try
import scalaz._, Scalaz._

val xa = DriverManagerTransactor[IOLite](
  "org.postgresql.Driver", "jdbc:postgresql:world", "postgres", ""
)

val y = xa.yolo; import y._
```

### Meta and Composite

The `doobie.free` API provides constructors for JDBC actions like `setString(1, "foo")` and `getBoolean(4)`, which operate on single columns specified by name or offset. Query parameters are set and resulting rows are read by repeated applications of these low-level actions.

The `doobie.hi` API abstracts the construction of these composite operations via the `Composite` typeclass, which provides actions to get or set a heterogeneous **sequence** of column values. For example, the following programs are equivalent:

```scala
// Using doobie.free
FPS.setString(1, "foo") *> FPS.setInt(2, 42)

// Using doobie.hi
HPS.set(1, ("foo", 42))

// Or leave the 1 out if you like, since we usually start there
HPS.set(("foo", 42))

// Which simply delegates to the Composite instance
Composite[(String,Int)].set(1, ("foo", 42))
```

**doobie** can derive `Composite` instances for primitive column types and options thereof, plus tuples, `HList`s, shapeless records, and case classes whose elements have `Composite` instances. These primitive column types are identified by `Meta` instances, which describe `null`-aware single-column mappings.

So our strategy for mapping custom types is to construct a new `Meta` instance (given `Meta[A]` you get `Composite[A]` and `Composite[Option[A]]` for free); and our strategy for multi-column mappings is to construct a new `Composite` instance. We consider both cases below.

### Meta by Invariant Map

Let's say we have a structured value that's represented by a single string in a legacy database. We also have conversion methods to and from the legacy format.

```scala
case class PersonId(department: String, number: Int) {
  def toLegacy = department + ":" + number
}

object PersonId {

  def fromLegacy(s: String): Option[PersonId] =
    s.split(":") match {
      case Array(dept, num) => Try(num.toInt).toOption.map(new PersonId(dept, _))
      case _                => None
    }

  def unsafeFromLegacy(s: String): PersonId =
    fromLegacy(s).getOrElse(throw new RuntimeException("Invalid format: " + s))

}

val pid = PersonId.unsafeFromLegacy("sales:42")
```

Because `PersonId` is a case class of primitive column values, we can already map it across two columns. We can look at its `Composite` instance and see that its column span is two:

```scala
scala> Composite[PersonId].length
res15: Int = 2
```

However if we try to use this type for a *single* column value (i.e., as a query parameter, which requires a `Param` instance - `Param` is like `Composite` but disallows nesting), it doesn't compile.

```
scala> sql"select * from person where id = $pid"
<console>:37: error: Could not find or construct Param[shapeless.::[PersonId,shapeless.HNil]].
Ensure that this type is an atomic type with an Atom instance in scope, or is an HList whose members
have Atom instances in scope. You can usually diagnose this problem by trying to summon the Atom
instance for each element in the REPL. See the FAQ in the Book of Doobie for more hints.
       sql"select * from person where id = $pid"
       ^
```

According to the error message we need a `Param[PersonId :: HNil]` instance which requires a `Meta` instance for each member, which means we need a `Meta[PersonId]`.

```scala
scala> Meta[PersonId]
<console>:38: error: Could not find an instance of Meta[PersonId]; you can construct one based on a primitive instance via `xmap`.
       Meta[PersonId]
           ^
```

... and we don't have one. So how do we get one? The simplest way is by basing it on an existing `Meta` instance, using `xmap`. So we simply provide `String => PersonId` and vice-versa and we're good to go.

```scala
implicit val PersonIdMeta: Meta[PersonId] =
  Meta[String].xmap(PersonId.unsafeFromLegacy, _.toLegacy)
```

Now it compiles as a column value and as a `Composite` that maps to a *single* column:

```scala
scala> sql"select * from person where id = $pid"
res18: doobie.util.fragment.Fragment = Fragment("select * from person where id = ?")

scala> Composite[PersonId].length
res19: Int = 1

scala> sql"select 'podiatry:123'".query[PersonId].quick.unsafePerformIO
  PersonId(podiatry,123)
```

Note that the `Composite` width is now a single column. The rule is: if there exists an instance `Meta[A]` in scope, it will take precedence over any automatic derivation of `Composite[A]`.

### Meta by Construction

Some modern databases support a `json` column type that can store structured data as a JSON document, along with various SQL extensions to allow querying and selecting arbitrary sub-structures. So an obvious thing we might want to do is provide a mapping from Scala model objects to JSON columns, via some kind of JSON serialization library.

We can construct a `Meta` instance for the argonaut `Json` type by using the `Meta.other` constructor, which constructs a direct object mapping via JDBC's `.getObject` and `.setObject`. In the case of PostgreSQL the JSON values are marshalled via the `PGObject` type, which encapsulates an uninspiring `(String, String)` pair representing the schema type and its string value.

Here we go:

```scala
implicit val JsonMeta: Meta[Json] =
  Meta.other[PGobject]("json").xmap[Json](
    a => Parse.parse(a.getValue).leftMap[Json](sys.error).merge, // failure raises an exception
    a => {
      val o = new PGobject
      o.setType("json")
      o.setValue(a.nospaces)
      o
    }
  )
```

```scala
scala> 1 + 1
res21: Int = 2
```

Given this mapping to and from `Json` we can construct a *further* mapping to any type that has an `EncodeJson` and `DecodeJson` instances. On failure we throw an exception; this indicates a logic or schema problem.

```scala
def codecMeta[A : EncodeJson : DecodeJson : TypeTag]: Meta[A] =
  Meta[Json].xmap[A](
    _.as[A].result.fold(p => sys.error(p._1), identity),
    _.asJson
  )
```

Let's make sure it works. Here is a simple data type with an argonaut encoder, taken straight from the website, and a `Meta` instance derived from the code above.

```scala
case class Person(name: String, age: Int, things: List[String])

implicit val PersonCodecJson =
  casecodec3(Person.apply, Person.unapply)("name", "age", "things")

implicit val PersonMeta = codecMeta[Person]
```

Now let's create a table that has a `json` column to store a `Person`.

```scala
val drop = sql"DROP TABLE IF EXISTS pet".update.run

val create =
  sql"""
    CREATE TABLE pet (
      id    SERIAL,
      name  VARCHAR NOT NULL UNIQUE,
      owner JSON    NOT NULL
    )
  """.update.run

(drop *> create).quick.unsafePerformIO
```

Note that our `check` output now knows about the `Json` and `Person` mappings. This is a side-effect of constructing instance above, which isn't a good design. Will revisit this for 0.3.0; this information is only used for diagnostics so it's not critical.

```
scala> sql"select owner from pet".query[Int].check.unsafePerformIO

  select owner from pet

  ✓ SQL Compiles and Typechecks
  ✕ C01 owner OTHER (json) NOT NULL  →  Int
    - OTHER (json) is not coercible to Int according to the JDBC specification or any
      defined mapping. Fix this by changing the schema type to INTEGER, or the Scala
      type to Person or Json or PGobject.
```

And we can now use `Person` as a parameter type and as a column type.

```scala
scala> val p = Person("Steve", 10, List("Train", "Ball"))
p: Person = Person(Steve,10,List(Train, Ball))

scala> (sql"insert into pet (name, owner) values ('Bob', $p)"
     |   .update.withUniqueGeneratedKeys[(Int, String, Person)]("id", "name", "owner")).quick.unsafePerformIO
  (1,Bob,Person(Steve,10,List(Train, Ball)))
```

If we ask for the `owner` column as a string value we can see that it is in fact storing JSON data.

```scala
scala> sql"select name, owner from pet".query[(String,String)].quick.unsafePerformIO
  (Bob,{"name":"Steve","age":10,"things":["Train","Ball"]})
```

### Composite by Invariant Map

We get `Composite[A]` and `Composite[Option[A]]` for free given `Meta[A]`, or for tuples, `HList`s, shapeless records, and case classes whose fields have `Composite` instances. This covers a lot of cases, but we still need a way to map other types. For example, what if we wanted to map a `java.awt.Point` across two columns? Because it's not a tuple or case class we can't do it for free, but we can get there via invariant map. Here we map `Point` to a pair of `Int` columns.

```scala
implicit val Point2DComposite: Composite[Point] =
  Composite[(Int, Int)].xmap(
    (t: (Int,Int)) => new Point(t._1, t._2),
    (p: Point) => (p.x, p.y)
  )
```

And it works!

```scala
scala> sql"select 'foo', 12, 42, true".query[(String, Point, Boolean)].unique.quick.unsafePerformIO
  (foo,java.awt.Point[x=12,y=42],true)
```
