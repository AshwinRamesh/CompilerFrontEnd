## Utility functions ##
## @author Ashwin Ramesh

class FunctionUndefinedException(Exception):

    def __init__(self, value):
        self.value = value


class MainUndefinedException(FunctionUndefinedException):
    pass


class VariableUndefinedException(Exception):

    def __init__(self, value):
        self.value = value


class RegisterUndefinedException(Exception):

    def __init__(self, value):
        self.value = value


class FunctionArgMismatchException(Exception):

    def __init__(self, function, given, required):
        self.function = function
        self.given = given
        self.required = required

class UndefinedIntermediateCodeException(Exception):

    def __init__(self, function, block, instruction):
        self.function = function
        self.block = block
        self.instruction = instruction
