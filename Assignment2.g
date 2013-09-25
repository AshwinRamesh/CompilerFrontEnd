grammar Assignment2;

@parser::header
{
    import java.util.HashMap;
    import java.util.ArrayList;
}

program
    locals
    [
        // functionDefs = map of function names -> number of arguments
        HashMap<String, Integer> functionDefs = new HashMap<String, Integer>(),
        // arraylist of pieces of intermediate code to be generated. To be joined into a string at the end
        ArrayList<String> code = new ArrayList<String>()
    ]
    @init
    {
        // utility necessary for handling expressions - maps '==' to 'cmp', etc.
        Assignment2Codegen.populateOpMap();

        // Program must start and end with bracket
        $program::code.add("(");
    }
    @after
    {
        Assignment2Semantics.checkMainDefined($program::functionDefs);

        // Program must start and end with bracket
        $program::code.add(")");
        System.out.println(Assignment2Codegen.join($program::code, " ")); 
    }
    : functions;

functions : function functions
    | ;

function
    locals 
    [
        // symbols defined in this function
        HashMap<String,Integer> symbols = new HashMap<String,Integer>(),
        // the block we are upto in this function (-1 => no blocks made)
        int currentBlock = -1,
        // list of block objects in this function
        ArrayList<Block> blocks = new ArrayList<Block>(),
        // maps variable name -> register holding it
        HashMap<String, Integer> variableRegister= new HashMap<String, Integer>(),
        // for if-then statements. the statement after if-then needs to be in a new block.
        // so this variable is basically a flag saying "we just finished an if-then statement."
        boolean newBlockRequired = false,
        //
        ArrayList<Block> fixmeBlocks = new ArrayList<Block>()
    ]
    @after
    {
        // Sometimes there is a new block required after we end a function
        if ($function::newBlockRequired) {
            Assignment2Codegen.createBlock($function::blocks, $function::currentBlock++, null);
        }
        
        // Adds jumps
        Assignment2Codegen.fixBlocks($fixmeBlocks);
       
        // Close blocks and function, add code to program
        Assignment2Codegen.closeFunction($blocks, $program::code);
    }
    : 'FUNCTION' ID arguments[true] variables 
    {
        Assignment2Semantics.handleFunctionDefinition($program::functionDefs, $ID.text, $arguments.args.size());
        Assignment2Codegen.addFunctionHeader($program::code, $ID.text, $arguments.args);
    } block[null];

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
    } ';'
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
    : a=ID {$return_ids.add($a.text);} (',' b=ID{$return_ids.add($b.text);})* 
    {
        Assignment2Semantics.handleIDList($function::symbols, $return_ids, $checkOnly);
    }
    ;

block[Block blParent] returns [Block basicBlock]: 'BEGIN' 
    {
        $basicBlock = Assignment2Codegen.createBlock($function::blocks, $function::currentBlock++, blParent);
    } statements 'END'
    ;
statements : statement ';' statements
    | ;

statement
    @init
    {
        // We just came out of an if-then statement! The stuff after that has to be in its own block.
        if ($function::newBlockRequired) {
            $function::newBlockRequired = false;
            Block b = Assignment2Codegen.createBlock($function::blocks, $function::currentBlock++, $block::basicBlock.getParent());
            // This block will need to have an appropriate jump after it, though
            $function::fixmeBlocks.add(b);
        }
    }
    : ID '=' expression
    {
        Assignment2Semantics.handleAssignmentStatement($function::symbols, $ID.text, $expression.value);
        Assignment2Codegen.addAssignmentStatement($function::blocks.get($function::currentBlock), $function::variableRegister,
                                                  $ID.text, $expression.register);
    }
    | 'IF' ID 'THEN'
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
        Block ifBlock = $function::blocks.get($function::currentBlock);
        int ldReg = Assignment2Codegen.addLoadVariable(ifBlock, $ID.text);
    } b1=block[$block::basicBlock] (el='ELSE' b2=block[$block::basicBlock])?
    {
        // Either we branch into the else
        // Or we branch into the block after the if-then, which will be currentBlock+1.
        // (because currentBlock has been updated by b1 and b2 already)
        int secondBranchBlock = $function::currentBlock + 1;
        // I couldn't do just b2 != null - don't ask me why, ask antlr.
        if ($el != null) {
            secondBranchBlock = $b2.basicBlock.getNumber();
        }

        // ifBlock and ldReg remain from above action
        ifBlock.addBR(ldReg, $b1.basicBlock.getNumber(), secondBranchBlock);

        // we finished an if-then: signify that the next statements should be in a new block
        $function::newBlockRequired = true;
    }
    | 'RETURN' ID
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
        Assignment2Codegen.addRet($function::blocks.get($function::currentBlock), $ID.text);
    }
    ;

expression returns [int value, int register]
    : NUM
    {
        $expression.value = $NUM.int;
        Block block = $function::blocks.get($function::currentBlock);
        int nextReg = block.getNextRegister(); // get the register this block is up to
        block.addLC(nextReg, $NUM.int);
        $expression.register = nextReg;
    }
    | ID
    {
        Assignment2Semantics.checkSymbolDefined($function::symbols, $ID.text);
        Block block = $function::blocks.get($function::currentBlock);
        int nextReg = block.getNextRegister();
        block.addLD(nextReg, $ID.text);

        $function::variableRegister.put($ID.text, nextReg);
        $expression.value = $function::symbols.get($ID.text);
        $expression.register = nextReg;
    }
    | ID arguments[false]
    {
        Assignment2Semantics.handleCallExpression($program::functionDefs, $ID.text, $arguments.args.size());
        Block block = $function::blocks.get($function::currentBlock);
        int reg;
        //load all the variables used in the function arguments into registers
        for ( String arg : $arguments.args) {
            reg = block.getNextRegister();
            block.addLD(reg, arg);
            //also map the variable to the register that holds it
            $function::variableRegister.put(arg, reg);
        }

        //(call <storage register> <function name> <argument registers>)
        block.add("( call");
        reg = block.getNextRegister();
        block.add(Assignment2Codegen.addR(reg));
        block.add($ID.text);

        //get the register that each variable is stored in and pass it as an argument to call
        for (String arg: $arguments.args) {
            block.add(Assignment2Codegen.addR($function::variableRegister.get(arg)));
        }
        block.add(") \n");

        $expression.value = 0;
        $expression.register = reg;
    }
    | '(' left=expression OP right=expression ')'
    {
        $expression.value = Assignment2Semantics.handleOperationExpression($OP.text, $left.value, $right.value);
        Block block = $function::blocks.get($function::currentBlock);
        int nextReg = block.getNextRegister();
        $expression.register = nextReg;
        block.addBooleanOp($OP.text, nextReg, $left.register, $right.register);

    }
    ;


WS : [ \t\r\n]+ -> skip;
ID : ('a'..'z'|'A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9')*;
OP : '+'|'-'|'*'|'/'|'<'|'>'|'==';
NUM : ('-')?('0'..'9')+;
