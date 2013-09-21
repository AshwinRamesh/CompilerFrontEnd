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
        ArrayList<String> code = new ArrayList<String>()
    ]
    @after
    {
        Assignment2Semantics.checkMainDefined($program::functionDefs);
        System.out.println(Assignment2Codegen.join($program::code, " ")); 
    }
    : { Assignment2Codegen.populateOpMap(); $program::code.add("(");} functions {$program::code.add(")");};

functions : function functions
    | ;

function
    locals 
    [
        /* symbols defined in this function */
        HashMap<String,Integer> symbols = new HashMap<String,Integer>(),
        int currentBlock = 0,
        ArrayList<Block> blocks = new ArrayList<Block>(),
        /* maps register number -> value stored in it */
        HashMap<Integer, Integer> registerValue = new HashMap<Integer, Integer>(),
        /* maps variable name -> register holding it */
        HashMap<String, Integer> variableRegister= new HashMap<String, Integer>()
    ]
    : 'FUNCTION' ID arguments[true] {
        $program::code.add( "(" + $ID.text + "(" + Assignment2Codegen.join($arguments.args, " ") + ")");
        //Create a new block, numbered with 0 and with the register counter set to 0. we start with r0
        $blocks.add(new Block(0, 0));
    }
    variables 
    {
        Assignment2Semantics.handleFunctionDefinition($program::functionDefs, $ID.text, $arguments.args.size());
    } block 
    { 
        for (Block block : $blocks) {
            $program::code.add(block.toString());
        }
        $program::code.add(")");
    }
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

variables returns [ArrayList<String> vars]: 'VARS' id_list[false]  
    {
        $vars = $id_list.return_ids;
    }';'
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

block 
    : 'BEGIN' 
      statements 'END' 
     ;

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

expression returns [int value, int register]
    : NUM
    {
        $expression.value = $NUM.int;
        Block block = $function::blocks.get($function::currentBlock);

        int nextReg = block.getNextRegister(); // get the register this block is up to
        $function::registerValue.put(nextReg, $NUM.int); //save the value of the register
        block.addLC(nextReg, $NUM.int);
        $expression.register = nextReg;
    }
    | ID
    {
        //generate:
        //(ld rx v)
        Block block = $function::blocks.get($function::currentBlock);
        int nextReg = block.getNextRegister();
        block.addLoad(nextReg, $ID.text);

        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
        $expression.value = $function::symbols.get($ID.text);
        $expression.register = nextReg;
    }
    //Function application
    | ID arguments[false]
    {
        Assignment2Semantics.handleCallExpression($program::functionDefs, $ID.text, $arguments.args.size());


        Block block = $function::blocks.get($function::currentBlock);

        int reg;
        //load all the variables used in the function arguments into registers
        for ( String arg : $arguments.args) {
            reg = block.getNextRegister();
            block.addLoad(reg, arg);
            //also map the variable to the register that holds it
            $function::variableRegister.put(arg, reg);
        }

        block.add("( call");
        reg = block.getNextRegister();
        block.add(Assignment2Codegen.addR(reg));
        block.add($ID.text);

        //get the register that each variable is stored in and pass it as an argument to call
        for (String arg: $arguments.args) {
            block.add(Assignment2Codegen.addR($function::variableRegister.get(arg)));
        }
        block.add(")");

        //TODO The register holding the result of the call is in the 'reg' variable.
        //TODO What do we do with it?

        //(call <storage register> <function name> <argument registers>)
        // TODO: Actually call the function
        $expression.value = 0;
        $expression.register = reg;
    }
    | '(' left=expression OP right=expression ')'
    {


        Block block = $function::blocks.get($function::currentBlock);
        int nextReg = block.getNextRegister();
        $expression.register = nextReg;
        block.addBooleanOp($OP.text, nextReg, $left.register, $right.register);

        $expression.value = Assignment2Semantics.handleOperationExpression($OP.text, $left.value, $right.value);
    }
    ;


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
