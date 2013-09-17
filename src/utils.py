## Utility functions ##
## @author Ashwin Ramesh

## Imports ##
import interpretterexceptions

def registers_exist(env, *args):
	for arg in args:
		if arg not in env["registers"].keys():
			raise RegisterUndefinedException(arg)
	return True

def variables_exist(env, *args):
	for arg in args:
		if arg not in env["variables"].keys():
			raise RegisterUndefinedException(arg)
	return True
