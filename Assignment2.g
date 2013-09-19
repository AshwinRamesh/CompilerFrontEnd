grammar Assignment2;
@parser::header
{
    import java.util.HashMap;
    import java.util.ArrayList;
}

program
    /* functionDefs = map of function names -> number of arguments */
    locals
    [
        HashMap<String, Integer> functionDefs = new HashMap<String, Integer>()
    ]
    @after
    {
        Assignment2Semantics.checkMainDefined($program::functionDefs);
    }
    : functions;

functions : function functions
    | ;

function
    /* symbols defined in this function */
    locals 
    [
        HashMap<String,Integer> symbols = new HashMap<String,Integer>()
    ]
    : 'FUNCTION' ID arguments[true] variables 
    {
        Assignment2Semantics.handleFunctionDefinition($program::functionDefs, $ID.text, $arguments.args.size());
    } block
    ;

/*
    isDeclaring: is this a declaration of arguments, or actually passing vars?
    This is sent to id_list to tell it whether we need to check only [passing]
    or insert these symbols to the function table [declaring].
 */
arguments[boolean isDeclaring] returns [ArrayList<String> args] : '(' id_list[!$isDeclaring] ')'
    {
        $args = $id_list.return_ids;
    }
    | '()'
    {
        $args = new ArrayList<String>();
    }
    ;

variables : 'VARS' id_list[false] ';'
    | ;

/*
   checkOnly: do we need to merely check the existence of the variable?
   That is, we don't want to set its value to anything.
   Done when in expression: ID arguments;
*/
id_list[boolean checkOnly] returns [ArrayList<String> return_ids]
    @init
    {
        $return_ids = new ArrayList<String>();
    }
    : a=ID {$return_ids.add($a.text);} (',' b=ID{$return_ids.add($b.text);})* //I have NO IDEA how to format this
    {
        Assignment2Semantics.handleIDList($function::symbols, $return_ids, $checkOnly);
    }
    ;

block : 'BEGIN' statements 'END' ;

statements : statement ';' statements
    | ;

statement 
    : ID '=' expression
    {
        Assignment2Semantics.handleAssignmentStatement($function::symbols, $ID.text, $expression.value);
    }
    | 'IF' ID 'THEN' block ('ELSE' block)?
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
    }
    | 'RETURN' ID
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
    }
    ;

expression returns [int value]
    : NUM
    {
        $expression.value = $NUM.int;
    }
    | ID
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
        $expression.value = $function::symbols.get($ID.text);
    }
    | ID arguments[false]
    {
        Assignment2Semantics.handleCallExpression($program::functionDefs, $ID.text, $arguments.args.size());
        
        // TODO: Actually call the function
        $expression.value = 0;
    }
    | '(' left=expression OP right=expression ')'
    {
        $expression.value = Assignment2Semantics.handleOperationExpression($OP.text, $left.value, $right.value);
    }
    ;


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
