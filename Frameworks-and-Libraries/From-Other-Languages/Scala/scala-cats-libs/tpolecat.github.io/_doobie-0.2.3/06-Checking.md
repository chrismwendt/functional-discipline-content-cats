---
layout: book
number: 6
title: Typechecking Queries
---

<div class="alert alert-warning" role="alert">
<b>Warning:</b> The functionality described in this chapter is experimental and is likely to change in future versions. But it's still pretty freakin' cool.
</div>

In this chapter we learn how to use YOLO mode to validate queries against the database schema and ensure that our type mappings are correct (and if not, get some hints on how to fix them).

### Setting Up

Our setup here is the same as last chapter, so if you're still running from last chapter you can skip this section. Otherwise: imports, `Transactor`, and YOLO mode.

```scala
import doobie.imports._
import scalaz._, Scalaz._
import scalaz.concurrent.Task

val xa = DriverManagerTransactor[Task](
  "org.postgresql.Driver", "jdbc:postgresql:world", "postgres", ""
)

import xa.yolo._
```

And again, we're playing with the `country` table, shown here for reference.

```sql
CREATE TABLE country (
  code        character(3)  NOT NULL,
  name        text          NOT NULL,
  population  integer NOT NULL,
  gnp         numeric(10,2),
  indepyear   smallint
  -- more columns, but we won't use them here
)
```

### Checking a Query

In order to create a query that's not quite right, let's redefine our `Country` class with slightly different types.

```scala
case class Country(code: Int, name: String, pop: Int, gnp: Double)
```

Here's our parameterized query from last chapter, but with the new `Country` definition and the `minPop` parameter changed to a `Short`. 

```scala
def biggerThan(minPop: Short) = sql"""
  select code, name, population, gnp, indepyear
  from country
  where population > $minPop
""".query[Country]
```

Now let's try the `check` method provided by YOLO and see what happens.

```
scala> biggerThan(0).check.run

    select code, name, population, gnp, indepyear
    from country
    where population > ?

  ✓ SQL Compiles and Typechecks
  ✕ P01 Short  →  INTEGER (int4)
    - Short is not coercible to INTEGER (int4) according to the JDBC specification.
      Fix this by changing the schema type to SMALLINT, or the Scala type to Int or
      JdbcType.
  ✕ C01 code       CHAR     (bpchar)  NOT NULL  →  Int
    - CHAR (bpchar) is ostensibly coercible to Int according to the JDBC specification
      but is not a recommended target type. Fix this by changing the schema type to
      INTEGER; or the Scala type to Code or String.
  ✓ C02 name       VARCHAR  (varchar) NOT NULL  →  String
  ✓ C03 population INTEGER  (int4)    NOT NULL  →  Int
  ✕ C04 gnp        NUMERIC  (numeric) NULL      →  Double
    - NUMERIC (numeric) is ostensibly coercible to Double according to the JDBC
      specification but is not a recommended target type. Fix this by changing the
      schema type to FLOAT or DOUBLE; or the Scala type to BigDecimal or BigDecimal.
    - Reading a NULL value into Double will result in a runtime failure. Fix this by
      making the schema type NOT NULL or by changing the Scala type to Option[Double]
  ✕ C05 indepyear  SMALLINT (int2)    NULL      →  
    - Column is unused. Remove it from the SELECT statement.
```

Yikes, there are quite a few problems, in several categories. In this case **doobie** found

- a parameter coercion that should always work but is not required to be supported by compliant drivers;
- two column coercions that **are** supported by JDBC but are not recommended and can fail in some cases;
- a column nullability mismatch, where a column that is *provably* nullable is read into a non-`Option` type;
- and an unused column.

Suggested fixes are given in terms of both JDBC and vendor-specific schema types and include known custom types like **doobie**'s enumerated `JdbcType`.  Currently this is based on instantiated `Meta` instances, which is not ideal; hopefully in the next release the tooling will improve to support all instances in scope.

Anyway, if we fix all of these problems and try again, we get a clean bill of health.

```scala
case class Country(code: String, name: String, pop: Int, gnp: Option[BigDecimal])

def biggerThan(minPop: Int) = sql"""
  select code, name, population, gnp
  from country
  where population > $minPop
""".query[Country]
```

```
scala> biggerThan(0).check.run

    select code, name, population, gnp
    from country
    where population > ?

  ✓ SQL Compiles and Typechecks
  ✓ P01 Int  →  INTEGER (int4)
  ✓ C01 code       CHAR    (bpchar)  NOT NULL  →  String
  ✓ C02 name       VARCHAR (varchar) NOT NULL  →  String
  ✓ C03 population INTEGER (int4)    NOT NULL  →  Int
  ✓ C04 gnp        NUMERIC (numeric) NULL      →  Option[BigDecimal]
```

**doobie** supports `check` for queries and updates in three ways: programmatically, via YOLO mode in the REPL, and via the `contrib-specs2` package, which allows checking to become part of your unit test suite. We will investigate this in the chapter on testing.

### Working Around Bad Metadata

Some drivers do not implement the JDBC metadata specification very well, which limits the usefulness of the query checking feature. MySQL and MS-SQL do a particularly rotten job in this department. In some cases queries simply cannot be checked because no metadata is available for the prepared statement (manifested as an exception) or the returned metadata is obviously inaccurate.

However a common case is that *parameter* metadata is unavailable but *output column* metadata is. And in these cases there is a workaround: use `checkOutput` rather than `check`. This instructs **doobie** to punt on the input parameters and only check output columns. Unsatisfying but better than nothing.

```
scala> biggerThan(0).checkOutput.run

    select code, name, population, gnp
    from country
    where population > ?

  ✓ SQL Compiles and Typechecks
  ✓ C01 code       CHAR    (bpchar)  NOT NULL  →  String
  ✓ C02 name       VARCHAR (varchar) NOT NULL  →  String
  ✓ C03 population INTEGER (int4)    NOT NULL  →  Int
  ✓ C04 gnp        NUMERIC (numeric) NULL      →  Option[BigDecimal]
```

This option is also available in the `contrib-specs2` package.

### Diving Deeper

The `check` logic requires both a database connection and concrete `Meta` instances that define column-level JDBC mappings. This could in principle happen at compile-time, but it's not clear that this is what you always want and it's potentially hairy to implement. So for now checking happens at unit-test time.

The way this works is that a `Query` value has enough type information to describe all parameter and column mappings, as well as the SQL literal itself (with interpolated parameters erased into `?`). From here it is straightforward to prepare the statement, pull the `ResultsetMetaData` and `DatabaseMetaData` and work out whether things are aligned correctly (and if not, determine how misalignments might be fixed). The `Anaylsis` class consumes this metadata and is able to provide the following diagnostics:

- SQL validity. The query must compile, which means it must be consistent with the schema.
- Parameter and column arity. All query inputs and outputs must map 1:1 with parameters and columns.
- Nullability. A parameter or column that is *provably* nullable must be mapped to a Scala `Option`. Note that this is a weak guarantee; columns introduced by an outer join might be nullable but JDBC will tend to report them as "might not be nullable" which isn't useful information.
- Coercibility of types. Mapping of Scala types to JDBC types and JDBC types to vendor types, is asymmetric with respect to reading and writing, and the specification is quite terrible. **doobie** encodes the JDBC spec and combines this with vendor-specific metadata to determine whether a given asserted mapping is sensible or not, and if not, will suggest a fix via changing the Scala type, and another via changing the schema type.








