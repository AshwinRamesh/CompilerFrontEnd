## Interpretter Implementation ##
# @author Ashwin Ramesh


## Process file ##

def process_file():
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
    functions = process_file()
    env = initialise_environment()
    # Do computation here ...
    print env

if __name__ == "__main__":
    main()
