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
        /* functionDefs = map of function names -> number of arguments */
        HashMap<String, Integer> functionDefs = new HashMap<String, Integer>(),
        /* arraylist of pieces of intermediate code to be generated. To be joined into a string at the end */
        ArrayList<String> code = new ArrayList<String>(),
        /* functionBlocks = map of function name -> list of blocks in it */
        HashMap<String, ArrayList<Block>> functionBlocks = new HashMap<String, ArrayList<Block>>();
    ]
    @after
    {
        Assignment2Semantics.checkMainDefined($program::functionDefs);
        System.out.println(Assignment2Codegen.join($program::code, " ")); 
    }
    : { $program::code.add("(");} functions {$program::code.add(")");};

functions : function functions
    | ;

function
    /* symbols defined in this function */
    locals 
    [
        HashMap<String,Integer> symbols = new HashMap<String,Integer>(),
        int currentBlock = 0

    ]
    : 'FUNCTION' ID arguments[true] {
        $program::code.add( "(" + $ID.text + "(" + Assignment2Codegen.join($arguments.args, " ") + ")");
    }
    variables 
    {

        Assignment2Semantics.handleFunctionDefinition($program::functionDefs, $ID.text, $arguments.args.size());
    } block { $program::code.add(")");}
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

block locals [
        int blockNum
    ]
    @init {

        $blockNum = $function::currentBlock++; 

    }: 'BEGIN' {
        $program::code.add("(" + $blockNum);
    }  statements 'END' {
        $program::code.add(")");
    } ;

statements : statement ';' statements
    | ;

statement 
    : ID '=' expression
    {
        //TODO Generate something like
        //<get register number that expression stored the result in>
        //(st ID r<number>)
        Assignment2Semantics.handleAssignmentStatement($function::symbols, $ID.text, $expression.value);
    }
    | 'IF' ID 'THEN' block ('ELSE' block)?
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
    }
    | 'RETURN' ID
    {
        //TODO Generate something like:
        //(ld r<number> ID)
        //(ret r<number>)
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
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
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
        $expression.value = $function::symbols.get($ID.text);
    }
    //Function application
    | ID arguments[false]
    {
        Assignment2Semantics.handleCallExpression($program::functionDefs, $ID.text, $arguments.args.size());
        
        // TODO: Actually call the function
        $expression.value = 0;
    }
    | '(' left=expression OP right=expression ')'
    {

        //For each of these, generate:
        //(ld ra $left.value)
        //(ld rb $right.value)
        //(add/sub/mul/div/[le]/gt/cmp rx ra rb)
        // rx now has the result of the expression
        $expression.value = Assignment2Semantics.handleOperationExpression($OP.text, $left.value, $right.value);
    }
    ;


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
