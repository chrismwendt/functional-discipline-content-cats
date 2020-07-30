// *****************************************************************************
// Projects
// *****************************************************************************

lazy val `scala-semigroup` =
  (project in file("."))
    .settings(settings)
    .settings(
      libraryDependencies ++= Seq(
        library.scalaTest % Test
      )
    )

// *****************************************************************************
// Library dependencies
// *****************************************************************************

lazy val library =
  new {

    object Version {
      val scalaTest = "3.0.4"
    }
	
    val scalaTest = "org.scalatest" %% "scalatest" % Version.scalaTest
  }

// *****************************************************************************
// Settings
// *****************************************************************************

lazy val settings = projectSettings

lazy val projectSettings =
  Seq(
    scalaVersion := "2.12.4",
    organization := "net.softler",
    version := "1.0.0",
    organizationName := "Tobias Frischholz",
    startYear := Some(2017),
    licenses += ("MIT", url("http://opensource.org/licenses/MIT")),
    scalacOptions ++= Seq(
      "-deprecation",
      "-encoding",
      "UTF-8",
      "-feature",
      "-unchecked",
      "-Ywarn-numeric-widen",
      "-Ywarn-value-discard",
      "-Xfatal-warnings",
      "-Yno-adapted-args",
      "-Xfuture"
    ),
    sources in (Compile, doc) := Seq.empty
  )