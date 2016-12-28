#!/bin/sh
# build an executable jar based on a single clojure file
# the jar has no dependencies other than the java runtime an clojure itself

# cleanup
rm -rf classes
rm -rf build

# create directories
mkdir -p classes
mkdir -p build

# compile clj
java -classpath lib/clojure-1.8.0.jar:src:classes clojure.main -e "(compile 'hello.core)"

# copy the clojure jar
cp lib/clojure-1.8.0.jar build/hello.jar

# update jar with compiled classes and change main method
jar -uvfe build/hello.jar hello.core -C classes/ .