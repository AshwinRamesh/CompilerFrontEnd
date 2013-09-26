## Utility functions ##
## @author Ashwin Ramesh

## Imports ##
from interpretterexceptions import VariableUndefinedException, RegisterUndefinedException, BlockUndefinedException

def registers_exist(env, *args):
	for arg in args:
		if arg not in env["registers"].keys():
			raise RegisterUndefinedException(arg)
	return True

def variables_exist(env, *args):
	for arg in args:
		if arg not in env["variables"].keys():
			raise VariableUndefinedException(arg)
	return True

def blocks_exist(name, function, args):
	for arg in args:
		if arg not in function["blocks"].keys():
			raise BlockUndefinedException(name, arg)
	return True

