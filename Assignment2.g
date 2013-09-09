grammar Assignment2;
@parser::header
{
    import java.util.HashMap;
}

program : functions;

functions : function functions
    | ;

function
/* symbols defined in this function */
locals
[
    HashMap<String,Integer> symbols = new HashMap<String,Integer>()
]
: 'FUNCTION' ID arguments[true] variables block;

/*
    isDeclaring: is this a declaration of arguments, or actually passing vars?
    This is sent to id_list to tell it whether we need to check only [passing]
    or insert these symbols to the function table [declaring].
 */
arguments[boolean isDeclaring] : '(' id_list[!$isDeclaring] ')'
    | '()';

variables : 'VARS' id_list[false] ';'
    | ;

/*
   checkOnly: do we need to merely check the existence of the variable?
   That is, we don't want to set its value to anything.
   Done when in expression: ID arguments;
*/
id_list[boolean checkOnly]
    : ID (',' id_list[$checkOnly])?
{
    if ($checkOnly) {
        if ($function::symbols.get($ID.text) == null) {
            System.err.println("Error: variable '"+$ID.text+"' undefined.");
	    // TODO: exception?
        }
    }
    else if ($function::symbols.get($ID.text) != null) {
        System.err.println("Error: variable '"+$ID.text+"' redefined.");
        // TODO: exception?
    }
    else {
        $function::symbols.put($ID.text, 0);
    }
}
    ;

block : 'BEGIN' statements 'END' ;

statements : statement ';' statements
    | ;

statement : ID '=' expression
    | 'IF' ID 'THEN' block ('ELSE' block)?
    | 'RETURN' ID;

expression : NUM
    | ID
    | ID arguments[false]
    | '(' expression OP expression ')';


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
