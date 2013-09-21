import java.util.Map;
import java.util.List;

public class Assignment2Semantics {

    public static void checkSymbolDefined(Map<String,Integer> funcSymbols, String id) {
        if (!funcSymbols.containsKey(id)) {
            throw new RuntimeException("Error: variable '"+id+"' undefined.");
        }
    }

    public static void checkMainDefined(Map<String,Integer> functionDefs) {
        if (!functionDefs.containsKey("main")) {
            throw new RuntimeException("Error: No main function defined.");
        }
    }
    
    public static void handleFunctionDefinition(Map<String,Integer> functionDefs, String name, int numArgs) {
        //if the function name has been seen already
        if (functionDefs.containsKey(name)) {
            throw new RuntimeException("Error: function '"+name+"' redefined.");
        }
        functionDefs.put(name, numArgs);
    }
    
    public static void handleIDList(Map<String,Integer> funcSymbols, List<String> ids, boolean checkOnly) {
        for(String id : ids) {
            if (checkOnly) {
                checkSymbolDefined(funcSymbols, id);
            }
            else if (funcSymbols.get(id) != null) {
                throw new RuntimeException("Error: variable '"+id+"' redefined.");
            }
            else {
                funcSymbols.put(id, 0);
            }
        }
    }
    
    public static void handleAssignmentStatement(Map<String,Integer> funcSymbols, String id, Integer expr) {
        if (funcSymbols.get(id) == null) {
            throw new RuntimeException("Error: variable '"+id+"' undefined.");
        }
        funcSymbols.put(id, expr);
    }
    
    public static void handleCallExpression(Map<String,Integer> functionDefs, String name, int numArgs) {
        // Check function defined
        if (!functionDefs.containsKey(name)) {
            throw new RuntimeException("Error: function '"+name+"' undefined.");
        }
        // Check num arguments
        if (functionDefs.get(name) != numArgs) {
            throw new RuntimeException("Error: function '"+name+"' expects "+numArgs+" arguments.");
        }
    }
    
    public static int handleOperationExpression(String op, int left, int right) {
        if (op.equals("+")) {
            return left+right;
        }
        if (op.equals("-")) {
            return left-right;
        }
        if (op.equals("*")) {
            return left*right;
        }
        if (op.equals("/")) {
            return left/right;
        }
        if (op.equals("<")) {
            return (left<right) ? 1 : 0;
        }
        if (op.equals(">")) {
            return (left>right) ? 1 : 0;
        }
        if (op.equals("==")) {
            return (left==right) ? 1 : 0;
        }
        throw new RuntimeException("Syntax Error");
    }
}
