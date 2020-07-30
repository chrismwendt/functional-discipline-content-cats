val externalDependencies = Seq(
  "com.chuusai"     %% "shapeless"    % "2.3.3",
  "com.github.ghik" %% "silencer-lib" % "1.6.0" % Provided cross CrossVersion.full,
  compilerPlugin("com.github.ghik" %% "silencer-plugin" % "1.6.0" cross CrossVersion.full),
  compilerPlugin("org.typelevel" %% "kind-projector" % "0.11.0" cross CrossVersion.full),
  "org.scalacheck"  %% "scalacheck"   % "1.14.3" % "test"
)

inThisBuild(Seq(
  scalaVersion          := "2.13.1",
  libraryDependencies   ++= externalDependencies
))

lazy val prjcSettings = Seq (
  version := "1.0.0",
  name 	  := "Laws"
)

lazy val `laws` = (project in file(".")).settings(prjcSettings: _*)

scalacOptions ++= Seq(
  "-deprecation",
  "-encoding",
  "UTF-8",
  "-explaintypes",
  "-Yrangepos",
  "-feature",
  "-language:higherKinds",
  "-language:existentials",
  "-unchecked",
  "-Xlint:_,-type-parameter-shadow",
  "-Xsource:2.13",
  "-Ywarn-dead-code",
  "-Ywarn-numeric-widen",
  "-Ywarn-value-discard",
  "-Xfatal-warnings",
  "-opt:l:inline",
  "-Ywarn-unused:imports",
  "-Ywarn-unused:_,imports",
  "-opt-warnings",
  "-Xlint:constant",
  "-Ywarn-extra-implicit",
  "-opt-inline-from:<source>"
)

scalacOptions in (Compile, console) --= Seq (
  "-Ywarn-unused:imports", 
  "-Xfatal-warnings"
)

scalacOptions in Test ++= Seq("-Yrangepos")

logLevel := Level.Info
