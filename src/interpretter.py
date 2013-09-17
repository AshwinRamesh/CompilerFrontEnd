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


## Process a single instruction ##
def process_instruction(instruction, environment):
    pass


## Process a block ##
def process_block(function, id):
    global functions
    block = functions[function]["blocks"][id]
    pass


## Process a function ##
def process_function(name):
    global functions
    function = functions[name]
    pass


##  Process the program ##
def process_program(args):
    global functions
    env = initialise_environment()
    print functions.keys()
    try:
        if "main" not in functions.keys():
            raise MainUndefinedException("main")
        if check_arg_length(functions["main"]['args'], args) != True:
            raise FunctionArgMismatchException("main", len(args), len(functions["main"]["args"]))
        print "Correct Input"
        # DO COMPUTATION HERE
        process_function("main")
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
        print "Error: Function '%s' requires %d arguments. %d given." %(e.function, e.required, e.given)
        exit(1)
    except Exception, e:
        print "Error: Unknown error."
        exit(1)


def main():
    global functions
    functions = parser.process_file("../tests/test_intermediate_1.txt");
    pp = pprint.PrettyPrinter(indent=2)
    pp.pprint(functions)
    process_program(sys.argv[1:])

if __name__ == "__main__":
    main()
