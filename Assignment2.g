//TODO: Find some way to keep track of the number of registers we have so far.
//Ideas: HashMap of register to value, and the length of the HashMap is the number of registers
//Potential problem: Can we lose a register? Can we ever have r1 r2 r3 r5 ?

//TODO: Decide when to start a 'basic block'. On branch? On return? Both? // On BEGIN seems like a good idea.
//But you need to look at everything between the BEGIN and END before you start generating code, since you need to know basic block numbers.
//Each FUNCTION has 1 or more basic blocks, not each program.
//TODO: Deal with the ambiguous IF ID THEN IF ID THEN BLOCK ELSE BLOCK //which if does the else go to? 

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
    : functions; //generate ( + functions + )

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
        //Generate:
        //( $ID.text (" ".join(arguments))
        //( 0
        //...<arbitrary> )

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
arguments[boolean isDeclaring] returns [ArrayList<String> args] : '(' id_list[!$isDeclaring] ')'
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

            if ($checkOnly) {
                if ($function::symbols.get(id.text) == null) {

                    throw new RuntimeException("Error: variable '"+id.text+"' undefined.");
                }
            }
            else if ($function::symbols.get(id.text) != null) {
                throw new RuntimeException("Error: variable '"+id.text+"' redefined.");
            }
            else {
                //Initialize new variables to 0
                $function::symbols.put(id.text, 0);
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
        //TODO Generate something like
        //<get register number that expression stored the result in>
        //(st ID r<number>)
        if ($function::symbols.get($ID.text) == null) {
            System.out.println($function::symbols.toString());
            throw new RuntimeException("Error: variable '"+$ID.text+"' undefined. MAXSWAG");
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
        //TODO Generate something like:
        //(ld r<number> ID)
        //(ret r<number>)

    	if ($function::symbols.get($ID.text) == null) {
            throw new RuntimeException("Error: variable '"+$ID.text+"' undefined.");
        }
    }
    ;

expression returns [int value]
    : NUM
    {
        $expression.value = $NUM.int;
        //generate
        //(ld rx $expression.value)
    }
    | ID
    {
        //generate:
        //(ld rx v)
        Integer v = $function::symbols.get($ID.text);
        if (v == null) {
                throw new RuntimeException("Error: variable '"+$ID.text+"' undefined.");
        }
        $expression.value = v;
    }
    //Function application
    | ID arguments[false]
    {
        
        System.out.println($program::functionNames.toString());
        if (!$program::functionNames.contains($ID.text)) {
	    System.err.println("Error: function '"+$ID.text+"' undefined.");
	}
	// TODO: check number of arguments match function definition
	// TODO: compute value by calling the function (HOW??)

    }
    | '(' left=expression OP right=expression ')'
    {

        //For each of these, generate:
        //(ld ra $left.value)
        //(ld rb $right.value)
        //(add/sub/mul/div/[le]/gt/cmp rx ra rb)
        // rx now has the result of the expression
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
