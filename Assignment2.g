grammar Assignment2;

//okay java
@parser::header {
    import java.util.ArrayList;
}

program locals [ArrayList<String> functionNames = new ArrayList<String>();] : functions;

functions : function functions
    | ;

function : 'FUNCTION' ID arguments variables block {


    //if the function name has been seen already
    if ($program::functionNames.contains($ID.text)) {
        //TODO
        //throw an error here, since we can't redefine a new function.
        //not sure how to do that with this assignment.
        //Exceptions? Just print it out?
    }
    else {
        $program::functionNames.add($ID.text);
    }
    //TODO: Remove this. It's for debugging so we can see which functions are defined as they are.
    //print the function we just defined
    System.out.println($program::functionNames.get($program::functionNames.size()-1));
    };

arguments : '(' id_list ')'
    | '()';

variables : 'VARS' id_list ';'
    | ;

id_list : ID
    | ID ',' id_list;

block : 'BEGIN' statements 'END' ;

statements : statement ';' statements
    | ;

statement : ID '=' expression
    //| 'IF' ID 'THEN' block
    | 'IF' ID 'THEN' block ('ELSE' block)?
    | 'RETURN' ID;

expression : NUM
    | ID
    | ID arguments
    | '(' expression OP expression ')';


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
