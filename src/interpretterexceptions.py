## Utility functions ##
## @author Ashwin Ramesh

class FunctionUndefinedException(Exception):

    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


class MainUndefinedException(FunctionUndefinedException):
    pass


class VariableUndefinedException(Exception):

    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)

class RegisterUndefinedException(Exception):

    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)

class FunctionArgMismatchException(Exception):

    def __init__(self, function, given, required):
        self.function = function
        self.given = given
        self.required = required

    def __str__(self):
        return repr(self.value) # change this to return 2 values
