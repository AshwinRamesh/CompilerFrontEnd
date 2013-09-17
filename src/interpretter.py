## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##
import parser, instructions, utils, exceptions
import pprint
import sys


## Initialise Environment ##
def initialise_environment():
    return {"variables": {}, "registers": {}}


## Check argument length ##
## Check that the number of args required equals param length
def check_arg_length(function_args, params):
    if len(function_args) != len(params):
        print "Error: Incorrect number of arguments provided"
        exit(1)
    return True


## Process a single instruction ##
def process_instruction(instruction, environment):
    name = instruction[0]

    if name == "lc":
        return load_constant(instruction)



## Process a block ##
def process_block(block):
    pass


## Process a function ##
def process_function(function):
    pass


##  Process the program ##
def process_program(functions, args):
    env = initialise_environment()

    if "main" not in functions.keys():
        print "Error: Main function not defined."
        exit(1)

    if check_arg_length(functions['main']['args'], args) == True:
        print "correct"

def main():
    functions = parser.process_file("../tests/test_intermediate_1.txt");
    pp = pprint.PrettyPrinter(indent=4)
    #pp.pprint(functions)
    process_program(functions, sys.argv[1:])

if __name__ == "__main__":
    main()
