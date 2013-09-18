## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##
import parser, instructions, utils
from interpretterexceptions import *
import pprint
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
    # Iterate instructions and execute
    for instruction in block:
        if instruction[0] == "lc":
            instructions.load_constant(env, instruction[1], instruction[2])
        elif instruction[0] == "ld":
            instructions.load_instructions(env, instruction[1], instruction[2])
        elif instruction[0] == "st":
            instructions.store_instructions(env, instruction[1], instruction[2])
        elif instruction[0] == "add":
            instructions.add(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "sub":
            instructions.sub(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "mul":
            instructions.mul(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "div":
            instructions.div(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "cmp":
            instructions.equals(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "lt":
            instructions.less_than(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "gt":
            instructions.greater_than(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "br":
            utils.blocks_exist(function, functions[function], instruction[2:4])
            branch = instructions.branch_change(env, instruction[1], instruction[2], instruction[3])
            return process_block(function, branch, env)
        elif instruction[0] == "ret":
            return instructions.return_from_function(env, instruction[1])
        elif instruction[0] == "call":
            instructions.call_function(env, functions, instruction[1], instruction[2], instruction[3:])
        else:
            raise UndefinedIntermediateCodeException(function, id, instruction[0])
    pass


## Process a function ##
def process_function(name, args, funcs = None):
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
    #print env
    return output


##  Process the program ##
def process_program(args=[]):
    global functions
    env = initialise_environment()
    if "main" not in functions.keys():
        raise MainUndefinedException("main")
    print process_function("main", args) # Print the final result


def main():
    global functions
    try:
        if len(sys.argv) <= 1:
            raise FileNotGivenException()
        functions = parser.process_file(sys.argv[1])
        pp = pprint.PrettyPrinter(indent=2)
        pp.pprint(functions)
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
    #except Exception, e:
    #    print "Error: Unknown error. %s" %()
    #    exit(1)


if __name__ == "__main__":
    main()
