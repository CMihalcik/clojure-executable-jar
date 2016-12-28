# Clojure Hello World Executable Jar

A toy example to demostrate building an executable jar from a clojure file without a proper build tool. The process only depends on the Java tools `java` and `jar` being on the path. Both are included when installing the Java JDK. Tested on OS X.

Versions

* java: [1.8.0_60](http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html#jdk-8u60-oth-JPR)
* clojure: [1.8.0](http://repo1.maven.org/maven2/org/clojure/clojure/1.8.0/clojure-1.8.0.zip)

Build with

    ./build.sh

Run with

    java -jar build/hello.jar

## Overview

To create an executable jar from a clojure source file we need to:

1. Create a clojure source file with a main method
2. Compile the file
3. Merge the compiled class files with those in the clojure .jar into a new .jar file whose manifest's `Main-Class` points at the class generated for the clojure file

## Process

Create a file `src/hello/core.clj` with `(:gen-class)` in the `ns` macro and a `(defn -main ...)` function

```clojure
(ns hello.Core
    (:gen-class))

(defn -main [] (println "Hello, World!"))
```

Create a diretory into which the compiled classes will be placed.

```bash
mkdir -p classes
```

Compile the clojure file using [compile](http://clojure.github.io/clojure/clojure.core-api.html#clojure.core/compile). You'll need to add the root directory in which the clojure source file is (`src`) to the classpath. The directory in which the compiled files will be placed (by default `classes`) needs to be added as well.

```bash
java -classpath lib/clojure-1.8.0.jar:src:classes clojure.main -e "(compile 'hello.Core)"
```

At this point, the `classes` directory should contain a `hello` directory with several .class files in it.

Next, build a jar with the generated classes and those from clojure.jar. For ease, we'll just copy clojure.jar and then modify it.

```bash
mkdir -p build
cp lib/clojure-1.8.0.jar build/hello.jar
jar -ufe build/hello.jar hello.Core -C classes/ .
```

Finally, run the jar. It should print `Hello, World!`

```bash
java -jar build/hello.jar
```

## References

* clojure enrty points: http://clojure.org/reference/repl_and_main
* clojure compilation: http://clojure.org/reference/compilation
* `jar` tool tutorial: http://docs.oracle.com/javase/tutorial/deployment/jar/index.html

