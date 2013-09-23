#runs each test in the target directory against the current Assignment2.g

#needs to be run in a directory containing antlr-4.1-complete.jar
export CLASSPATH=".:$PWD/antlr-4.1-complete.jar:$CLASSPATH"
alias antlr4="java -jar $PWD/antlr-4.1-complete.jar"
alias grun='java org.antlr.v4.runtime.misc.TestRig'

for file in $PWD/tests/*.dae
do
    echo "FILE: \n" $file "\n";
    cat $file;
    echo "OUTPUT:\n"
    antlr4 Assignment2.g -o build;
    javac build/Assignment2*.java;
    cd build;
    grun Assignment2 program $file ;
    cd ..;
    echo "\n\n\n"
done
