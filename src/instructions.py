## Interpretter Implementation ##
# @author Ashwin Ramesh


def load_constant(environment, register, value):
    environment['registers'][register] = value
    return environment


def store_instructions(environment, register, var):
    if register not in environment['registers'].keys():
        return False
    environment['registers'][register] = environment['variables'][var]
    return environment


def load_instructions(environment, register, var):
    if var not in environment['variables'].keys():
        return False
    environment['variables'][var] = environment['registers'][register]
    return environment


def add(environment, register_store, register_one, register_two):
    if (register_one not in environment['variables'].keys()) or (register_two not in environment['variables'].keys()):
        return False
    environment['registers'][register_store] = environment['registers'][register_one] + environment['registers'][register_two]
    return environment


def sub(environment, register_store, register_one, register_two):
    if (register_one not in environment['variables'].keys()) or (register_two not in environment['variables'].keys()):
        return False
    environment['registers'][register_store] = environment['registers'][register_one] - environment['registers'][register_two]
    return environment


def mul(environment, register_store, register_one, register_two):
    if (register_one not in environment['variables'].keys()) or (register_two not in environment['variables'].keys()):
        return False
    environment['registers'][register_store] = environment['registers'][register_one] * environment['registers'][register_two]
    return environment

def div(environment, register_store, register_one, register_two):
    if (register_one not in environment['variables'].keys()) or (register_two not in environment['variables'].keys()):
        return False
    environment['registers'][register_store] = environment['registers'][register_one] / environment['registers'][register_two]
    return environment


def equals(environment, register_store, register_one, register_two):
    print "stub"


def less_than(environment, register_store, register_one, register_two):
    print "stub"


def greater_than(environment, register_store, register_one, register_two):
    print "stub"


def branch_change(environment, register, block_zero, block_one):
    print "stub"


def return_from_function(environment, register):
    print "stub"

