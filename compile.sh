#program could be name of statement to use
#$1 = input file
#$2 = output filename
export CLASSPATH=".:$PWD/antlr-4.1-complete.jar:$CLASSPATH"
alias antlr4="java -jar $PWD/antlr-4.1-complete.jar"
alias grun='java org.antlr.v4.runtime.misc.TestRig'

antlr4 Assignment2.g -o build &&  javac build/Assignment2*.java && grun Assignment2 program  < $1 > $2

