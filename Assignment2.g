grammar Assignment2;

program : functions;

functions : function functions
    | ;

function : 'FUNCTION' ID arguments variables block;

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
