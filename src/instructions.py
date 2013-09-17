## Interpretter Implementation ##
# @author Ashwin Ramesh

## Imports ##
from utils import registers_exist, variables_exist
import interpretter
from math import floor


def load_constant(environment, register, value):
    environment['registers'][register] = value
    return environment


def load_instructions(environment, register, var):
    variables_exist(environment, var)
    environment['registers'][register] = environment['variables'][var]
    return environment


def store_instructions(environment, register, var):
    registers_exist(environment, register)
    environment['variables'][var] = environment['registers'][register]
    return environment


def add(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    environment['registers'][register_store] = environment['registers'][register_one] + environment['registers'][register_two]
    return environment


def sub(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    environment['registers'][register_store] = environment['registers'][register_one] - environment['registers'][register_two]
    return environment


def mul(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    environment['registers'][register_store] = int(environment['registers'][register_one] * environment['registers'][register_two])
    return environment

def div(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    environment['registers'][register_store] = int(environment['registers'][register_one] / environment['registers'][register_two])
    return environment

def equals(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    if environment['registers'][register_one] == environment['registers'][register_two]:
        environment['registers'][register_store] = 1
    else:
        environment['registers'][register_store] = 0
    return environment


def less_than(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    if environment['registers'][register_one] < environment['registers'][register_two]:
        environment['registers'][register_store] = 1
    else:
        environment['registers'][register_store] = 0
    return environment


def greater_than(environment, register_store, register_one, register_two):
    registers_exist(environment, register_one, register_two)
    if environment['registers'][register_one] > environment['registers'][register_two]:
        environment['registers'][register_store] = 1
    else:
        environment['registers'][register_store] = 0
    return environment


# TODO
def branch_change(environment, register, block_zero, block_one):
    registers_exist(environment, register)
    if environment['registers'][register] == 0:
        pass # go to block_one
    else:
        pass # go to block_zero


def return_from_function(environment, register): # TODO later
    return environment['registers'][register]


def call_function(environment, return_register, function, args):
    for arg in args:
        registers_exist(environment, arg)
    val = interpretter.process_function(function, args)
    environment['registers'][return_register] = val
    return environment



