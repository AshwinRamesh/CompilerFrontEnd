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
            pass
        elif instruction[0] == "st":
            pass
        elif instruction[0] == "add":
            instructions.add(env, instruction[1], instruction[2], instruction[3])
        elif instruction[0] == "sub":
            pass
        elif instruction[0] == "mul":
            pass
        elif instruction[0] == "div":
            pass
        elif instruction[0] == "cmp":
            pass
        elif instruction[0] == "lt":
            pass
        elif instruction[0] == "gt":
            pass
        elif instruction[0] == "br":
            pass
        elif instruction[0] == "ret":
            return instructions.return_from_function(env, instruction[1])
        elif instruction[0] == "call":
            pass
        else:
            raise UndefinedIntermediateCodeException(function, id, instruction[0])
    pass


## Process a function ##
def process_function(name, args):
    global functions
    # Initialise env
    function = functions[name]
    env = initialise_environment()

    # Check for arg length
    if check_arg_length(functions["main"]['args'], args) != True:
        raise FunctionArgMismatchException(name, len(args), len(functions[name]["args"]))

    # Parse args and place in env
    for i in range(0, len(args)):
        env["variables"][function["args"][i]] = args[i]

    # Process blocks
    output = process_block(name, 0, env)
    print env
    return output


##  Process the program ##
def process_program(args=[]):
    global functions
    env = initialise_environment()
    try:
        if "main" not in functions.keys():
            raise MainUndefinedException("main")
        print process_function("main", args)
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
   #except Exception, e:
   #    print "Error: Unknown error. %s" %()
   #    exit(1)


def main():
    global functions
    functions = parser.process_file("../tests/intermediate-code-tests/add.test"); # TODO: make this dynamic
    pp = pprint.PrettyPrinter(indent=2)
    pp.pprint(functions)
    process_program(sys.argv[1:])

if __name__ == "__main__":
    main()
