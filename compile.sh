#program could be name of statement to use
#$1 = input file
#$2 = output filename


if [ $# -ne 2 ]
  then
    echo "Wrong number of arguments!\n"
    echo "Usage: ./compile.sh <input file path> <output file path>\n"
    exit 1
fi
export CLASSPATH=".:$PWD/antlr-4.1-complete.jar:$CLASSPATH"
export CLASSPATH=".:$PWD/build/:$CLASSPATH"

alias antlr4="java -jar $PWD/antlr-4.1-complete.jar"
alias grun='java org.antlr.v4.runtime.misc.TestRig'

antlr4 Assignment2.g -o build;
javac build/Assignment2*.java;

java -cp build Assignment2  $1  > $2

