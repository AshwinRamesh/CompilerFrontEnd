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

block returns [Block basicBlock]: 'BEGIN' 
    {
        if ($function::blocks.size() == 0) {
            $basicBlock = new Block(0,0);
        }
        else {
            $basicBlock = new Block($function::currentBlock + 1 , $function::blocks.get($function::currentBlock).getNextRegister());
            $function::currentBlock++;
        }
        $function::blocks.add($basicBlock);
    } statements 'END'
     ;

statements : statement ';' statements
    | ;

statement 
    : ID '=' expression
    {
        Block block = $function::blocks.get($function::currentBlock);
        block.addST($ID.text, $expression.register);
        System.out.println("added" + $ID.text);
        System.out.println($function::variableRegister.toString());
        $function::variableRegister.put($ID.text, $expression.register);
        Assignment2Semantics.handleAssignmentStatement($function::symbols, $ID.text, $expression.value);
    }
    | 'IF' ID 'THEN'
    {
        Block block = $function::blocks.get($function::currentBlock);
        //break on ID. If it's true, go the the block after the THEN, else go after the IF, which *should* be the next block numerically
        //TODO uncomment this when variableRegister actually works
        System.out.println("asking for" + $ID.text);
        System.out.println($function::variableRegister.toString());
        System.out.println($block::basicBlock);

        //add (ld rx ID)
        int reg = block.getNextRegister();
        //load the register we'll be branching on
        block.addLoad(reg, $ID.text);
        block.addBR(reg, $block::basicBlock.getNumber(), block.getNumber() + 1);
    } block ('ELSE' block {} )? 
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
    }
    | 'RETURN' ID
    {
        // TODO: uncomment this when every variable is actually mapped to a register
        Block block = $function::blocks.get($function::currentBlock);
        block.add("( ret");
        System.out.println("asking for" + $ID.text);
        System.out.println($function::variableRegister.toString());
        block.add(Assignment2Codegen.addR($function::variableRegister.get($ID.text)));
        block.add(")");
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

        Block block = $function::blocks.get($function::currentBlock);
        int nextReg = block.getNextRegister();
        block.addLoad(nextReg, $ID.text);

        System.out.println("adding" + $ID.text);
        System.out.println($function::variableRegister.toString());
        $function::variableRegister.put($ID.text, nextReg);
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

            System.out.println("adding" + arg);
            System.out.println($function::variableRegister.toString());
            $function::variableRegister.put(arg, reg);
        }

        block.add("( call");
        reg = block.getNextRegister();
        block.add(Assignment2Codegen.addR(reg));
        block.add($ID.text);

        //get the register that each variable is stored in and pass it as an argument to call
        for (String arg: $arguments.args) {
            System.out.println("asking for" + arg);
            System.out.println($function::variableRegister.toString());
            block.add(Assignment2Codegen.addR($function::variableRegister.get(arg)));
        }
        block.add(")");

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
