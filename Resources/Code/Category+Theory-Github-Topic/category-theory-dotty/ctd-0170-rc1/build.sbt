val dottyVersion = "0.17.0-RC1"

lazy val `ctd-0160-rc3` = project
  .in(file("."))
  .settings(
    version := "0.1.0",

    scalaVersion := dottyVersion,

    libraryDependencies ++= Seq(
      "junit" % "junit" % "4.12",
      "com.novocode" % "junit-interface" % "0.11" % "test"
    )
  )
