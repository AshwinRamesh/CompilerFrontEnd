## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##
import parser, instructions, utils
from interpretterexceptions import *
import sys

## Global Variables ##
functions = {} # parsed functions


## Initialise Environment ##
def initialise_environment():
    return {"variables": {}, "registers": {}}


## Check argument length ##
## Check that the number of args required equals param length
def check_arg_length(function_args, params):
    if len(function_args) != len(params):
        return False
    return True


## Process a block ##
def process_block(function, id, env):
    global functions
    block = functions[function]["blocks"][id]
    last_instruction = None
    # Iterate instructions and execute
    for instruction in block:
        last_instruction = instruction
        operation = instruction[0]
        args = instruction[1:]
        if operation == "lc":
            instructions.load_constant(env, args[0], args[1])
        elif operation == "ld":
            instructions.load_instructions(env, args[0], args[1])
        elif operation == "st":
            instructions.store_instructions(env, args[0], args[1])
        elif operation == "add":
            instructions.add(env, args[0], args[1], args[2])
        elif operation == "sub":
            instructions.sub(env, args[0], args[1], args[2])
        elif operation == "mul":
            instructions.mul(env, args[0], args[1], args[2])
        elif operation == "div":
            instructions.div(env, args[0], args[1], args[2])
        elif operation == "cmp":
            instructions.equals(env, args[0], args[1], args[2])
        elif operation == "lt":
            instructions.less_than(env, args[0], args[1], args[2])
        elif operation == "gt":
            instructions.greater_than(env, args[0], args[1], args[2])
        elif operation == "br":
            utils.blocks_exist(function, functions[function], args[1:3])
            branch = instructions.branch_change(env, args[0], args[1], args[2])
            return process_block(function, branch, env)
        elif operation == "ret":
            return instructions.return_from_function(env, args[0])
        elif operation == "call":
            instructions.call_function(env, functions, args[0], args[1], args[2:])
        else:
            raise UndefinedIntermediateCodeException(function, id, operation)
    # Check if last instruction is non-return
    if (last_instruction == None or (last_instruction[0] != "ret" and last_instruction[0] != "br")):
        id = id + 1
        utils.blocks_exist(function, functions[function], [id])
        return process_block(function, id, env)
    pass



## Process a function ##
def process_function(name, args, funcs=None):
    global functions
    if funcs != None: # Done when functions call functions. Redefine the scope of the globals
        functions = funcs
    # Initialise env
    if name not in functions.keys():
        raise FunctionUndefinedException(name)
    function = functions[name]
    env = initialise_environment()

    # Check for arg length
    if check_arg_length(functions[name]['args'], args) != True:
        raise FunctionArgMismatchException(name, len(args), len(functions[name]["args"]))

    # Parse args and place in env
    for i in range(0, len(args)):
        env["variables"][function["args"][i]] = int(args[i])

    # Process blocks
    output = process_block(name, 0, env)
    return output


##  Process the program ##
def process_program(args=[]):
    global functions
    if "main" not in functions.keys():
        raise MainUndefinedException("main")
    print process_function("main", args) # Print the final result


def main():
    global functions
    try:
        if len(sys.argv) <= 1:
            raise FileNotGivenException()
        functions = parser.process_file(sys.argv[1])
        process_program(sys.argv[2:])
    except IOError:
        print "Error: File does not exist. Cannot execute."
        exit(1)
    except FileNotGivenException as e:
        print "Error: No input file given. Cannot execute."
        exit(1)
    except FunctionUndefinedException as e:
        print "Error: Function name '%s' is undefined." %(e.value)
        exit(1)
    except VariableUndefinedException as e:
        print "Error: Variable '%s' is undefined." %(e.value)
        exit(1)
    except RegisterUndefinedException as e:
        print "Error: Register '%s' is undefined." %(e.value)
        exit(1)
    except FunctionArgMismatchException as e:
        print "Error: Function '%s' requires %d argument(s), but %d given." %(e.function, e.required, e.given)
        exit(1)
    except UndefinedIntermediateCodeException as e:
        print "Error: Intermediate function '%s' in function '%s' on block %d is undefined." %(e.instruction, e.function, e.block)
        exit(1)
    except BlockUndefinedException as e:
        print "Error: Block %d does not exist in function '%s'." %(e.block, e.function)
        exit(1)
    except IndexError:
        print "Error: Corrupted intermediate file. Cannot execute."
        exit(1)


if __name__ == "__main__":
    main()
