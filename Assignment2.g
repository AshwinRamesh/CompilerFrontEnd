grammar Assignment2;
@parser::header
{
    import java.util.HashMap;
    import java.util.ArrayList;
}

program
    locals
    [
        ArrayList<String> functionNames = new ArrayList<String>()
    ]
    @after
    {
        if (!$program::functionNames.contains("main")) {
	    throw new RuntimeException("Error: No main function defined.");
	}
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
    : 'FUNCTION' ID arguments[true] variables block
    {
    	// Set the name of our function
        //if the function name has been seen already
        if ($program::functionNames.contains($ID.text)) {
            throw new RuntimeException("Error: function '"+$ID.text+"' redefined.");
        }
        else {
            $program::functionNames.add($ID.text);
        }
    }
    ;

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
id_list[boolean checkOnly] returns [List<Token> return_ids]
    : ids+=ID (',' ids+=ID)*
    {
        $return_ids = $ids; //YEAH OKAY

        for(Token id : $ids) {
            String idText = id.getText();
            if ($checkOnly) {
                if ($function::symbols.get(idText) == null) {

                    throw new RuntimeException("Error: variable '"+idText+"' undefined.");
                }
            }
            else if ($function::symbols.get(idText) != null) {
                throw new RuntimeException("Error: variable '"+idText+"' redefined.");
            }
            else {
                $function::symbols.put(idText, 0);
            }
        }
    }
    ;

block : 'BEGIN' statements 'END' ;

statements : statement ';' statements
    | ;

statement 
    : ID '=' expression
    {
        if ($function::symbols.get($ID.text) == null) {
            throw new RuntimeException("Error: variable '"+$ID.text+"' undefined.");
	}
	$function::symbols.put($ID.text, $expression.value);
    }
    | 'IF' ID 'THEN' block ('ELSE' block)?
    {
        if ($function::symbols.get($ID.text) == null) {
            throw new RuntimeException("Error: variable '"+$ID.text+"' undefined.");
	}
    }
    | 'RETURN' ID
    {
    	if ($function::symbols.get($ID.text) == null) {
            throw new RuntimeException("Error: variable '"+$ID.text+"' undefined.");
        }
    }
    ;

expression returns [int value]
    : NUM
    {
        $expression.value = $NUM.int;
    }
    | ID
    {
        Integer v = $function::symbols.get($ID.text);
	if (v == null) {
            throw new RuntimeException("Error: variable '"+$ID.text+"' undefined.");
	}
	$expression.value = v;
    }
    | ID arguments[false]
    {
        if (!$program::functionNames.contains($ID.text)) {
	    System.err.println("Error: function '"+$ID.text+"' undefined.");
	}
	// TODO: check number of arguments match function definition
	// TODO: compute value by calling the function (HOW??)

    }
    | '(' left=expression OP right=expression ')'
    {
    	if ($OP.text.equals("+")) {
	    $expression.value = $left.value+$right.value;
	}
	if ($OP.text.equals("-")) {
            $expression.value = $left.value-$right.value;
	}
	if ($OP.text.equals("*")) {
	    $expression.value = $left.value*$right.value;
	}
	if ($OP.text.equals("/")) {
	    $expression.value = $left.value/$right.value;
	}
	if ($OP.text.equals("<")) {
	    $expression.value = ($left.value<$right.value) ? 1 : 0;
	}
	if ($OP.text.equals(">")) {
	    $expression.value = ($left.value>$right.value) ? 1 : 0;
	}
	if ($OP.text.equals("==")) {
	    $expression.value = ($left.value==$right.value) ? 1 : 0;
	}
    }
    ;


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
