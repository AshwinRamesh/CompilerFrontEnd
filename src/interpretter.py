## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##
import sexp
import pprint
import sys

## Process file ##
def process_file(file_name):
    try:    # check if file exists
        with open(file_name): pass
    except IOError:
        print "Intermediate Code File does not exist. Exiting..."
        exit()
    # read file
    with open(file_name, 'r') as content_file:
        content = content_file.read()
    return sexp.parse(content);

## Initialise Environment ##
def initialise_environment():
    return {"variables": {}, "registers": {}}

## Instructions ##

def load_constant(environment, register, value):
    print "stub"

def load_instructions(environment, register, value):
    print "stub"

def store_instructions(environment, register, value):
    print "stub"

def add(environment, register_one, register_two, register_store):
    print "stub"

def sub(environment, register_one, register_two, register_store):
    print "stub"

def mul(environment, register_one, register_two, register_store):
    print "stub"

def div(environment, register_one, register_two, register_store):
    print "stub"

def equals(environment, register_one, register_two, register_store):
    print "stub"

def less_than(environment, register_one, register_two, register_store):
    print "stub"

def greater_than(environment, register_one, register_two, register_store):
    print "stub"

def branch_change(environment, register, block_zero, block_one):
    print "stub"

def return_from_function(environment, register):
    print "stub"

### End of Instructions ###

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





##  Process the program ##
def process_program(functions, args):
    env = initialise_environment()

    if "main" not in functions.keys():
        print "Error: Main function not defined."
        exit(1)

    if check_arg_length(functions['main']['args'], args) == True:
        print "correct"

def main():
    functions = process_file("../tests/test_intermediate_1.txt");
    pp = pprint.PrettyPrinter(indent=4)
    #pp.pprint(functions)
    process_program(functions, sys.argv[1:])

if __name__ == "__main__":
    main()
