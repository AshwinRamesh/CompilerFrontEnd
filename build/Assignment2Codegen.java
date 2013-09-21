import java.util.ArrayList;
import java.util.HashMap;
class Assignment2Codegen {

    public static HashMap<String, String> opMap = new HashMap<String, String>();


    public static void populateOpMap() {
        String[] languageOps = {"+","-", "/","*", "<", ">", "=="};
        String[] intermediateOps = {"add", "sub", "div", "mul", "le", "gt", "cmp"};
        for (int i = 0; i < languageOps.length; i++) {
            opMap.put(languageOps[i], intermediateOps[i]);
        }
    }
    //add the 'r' to a register number. 2 -> 'r2'
    public static String addR(int number) {
        return "r" + number;
    }
    //Returns a string with each element in the ArrayList seperated by the string sep
    //Similar to Python/JavaScript's join function
    public static String join(ArrayList<String> list, String sep) {

        StringBuilder sb = new StringBuilder();
        //loop to every element except the last one so we don't add the separator on the end
        for (int i = 0; i < list.size() - 1; i++)
        {
            sb.append(list.get(i) + sep);
        }
        sb.append(list.get(list.size() - 1));

        return sb.toString();

    }


}

class Block {

    private ArrayList<String> code;
    private int number;
    private int currentRegister;

    // Used to create an empty block, in case we need to do that.
    public Block() {
        code = new ArrayList<String>();
        code.add("(");
    }

    public Block(int number, int register) {
        code = new ArrayList<String>();
        this.number = number;
        this.currentRegister = register;
        code.add("(" + number);
    }

    public void endBlock() {
        code.add(")");
    }

    //Adds some code to the code in this block
    public void add(String str) {
        code.add(str);
    }

    public void addLoad(int register, String value) {
        code.add("(");
        code.add("ld");
        code.add(Assignment2Codegen.addR(register));
        code.add(value);
        code.add(")");
    }

    public void addLC(int register, int constant) {
        code.add("(");
        code.add("lc");
        code.add(Assignment2Codegen.addR(register));
        code.add(Integer.toString(constant));
        code.add(")");
    }

    public void addST(String variable, int register) {
        code.add("(");
        code.add("st");
        code.add(variable);
        code.add(Assignment2Codegen.addR(register));
        code.add(")");
    }
    public int getCurrentRegister() {
        return currentRegister;
    }

    public int getNextRegister() {
        return currentRegister++;
    }

    public String toString() {
        return Assignment2Codegen.join(code, " ");
    }

    public void addBooleanOp(String op, int rStore, int r1, int r2){
        code.add("(");
        code.add(Assignment2Codegen.opMap.get(op));
        code.add(Assignment2Codegen.addR(rStore));
        code.add(Assignment2Codegen.addR(r1));
        code.add(Assignment2Codegen.addR(r2));
        code.add(")");
    }


}
