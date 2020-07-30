name := "category-theory-for-programmers-scala"

version := "0.1"

scalaVersion := "2.13.0"

resolvers += Resolver.sonatypeRepo("releases")
resolvers += "Artima Maven Repository" at "http://repo.artima.com/releases"

addCompilerPlugin("org.typelevel" %% "kind-projector" % "0.10.3")

libraryDependencies += "org.scalactic"  %% "scalactic"  % "3.0.8"  % "test"
libraryDependencies += "org.scalatest"  %% "scalatest"  % "3.0.8"  % "test"
libraryDependencies += "org.scalacheck" %% "scalacheck" % "1.14.0" % "test"

sonarUseExternalConfig := true
coverageEnabled := true
coverageHighlighting := true

addCommandAlias("fmt", "all scalafmtSbt scalafmt test:scalafmt")
addCommandAlias("check", "all scalafmtSbtCheck scalafmtCheck test:scalafmtCheck")
