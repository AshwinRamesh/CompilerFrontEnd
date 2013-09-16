## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##

import sexp

## Process file ##

def process_file(file_name):
    # check if file exists
    try:
        with open(file_name): pass
    except IOError:
        print "Intermediate Code File does not exist. Exiting..."
        exit()
    # read file
    with open(file_name, 'r') as content_file:
        content = content_file.read()
    parsed_file = sexp.parse(content);
    return parsed_file
    functions = {}
    # do processing here...
    return functions

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





def main():
    functions = process_file("../tests/test_intermediate_1.txt");
    #env = initialise_environment()
    ## Do computation here ...
    #a = sexp.parse("(a a (b) (c))");
    #print a[0][0][0]
    #print env

if __name__ == "__main__":
    main()
