## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##
import parser, instructions, utils
from exceptions import FunctionUndefinedException, MainUndefinedException, VariableUndefinedException, RegisterUndefinedException, FunctionArgMismatchException
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
def process_block(block):
    pass


## Process a function ##
def process_function(function):
    pass


##  Process the program ##
def process_program(args):
    env = initialise_environment()
    try:
        if "main" not in functions.keys():
            raise MainUndefinedException("main")
        if check_arg_length(functions["main"]['args'], args) != True:
            raise FunctionArgMismatchException("main" len(args), len(functions["main"]["args"]))
        print "Correct Input"

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
    functions = parser.process_file("../tests/test_intermediate_1.txt");
    #pp = pprint.PrettyPrinter(indent=4)
    #pp.pprint(functions)
    process_program(sys.argv[1:])

if __name__ == "__main__":
    main()
