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

    public void addInstruction(String op, String arg1, String arg2)
    {
        code.add("(");
        code.add(op);
        code.add(arg1);
        code.add(arg2);
        code.add(")");
    }

    public void addInstruction(String op, String arg1, String arg2, String arg3)
    {
        code.add("(");
        code.add(op);
        code.add(arg1);
        code.add(arg2);
        code.add(arg3);
        code.add(")");
    }

    public Block(int number, int register) {
        code = new ArrayList<String>();
        this.number = number;
        this.currentRegister = register;
        code.add("(" + number + '\n');
    }

    public void endBlock() {
        code.add(")");
    }

    //Adds some code to the code in this block
    public void add(String str) {
        code.add(str);
    }

    public void addLD(int register, String value) {
        addInstruction("ld", Assignment2Codegen.addR(register), value);
    }

    public void addLC(int register, int constant) {
        addInstruction("lc", Assignment2Codegen.addR(register), Integer.toString(constant));
    }

    public void addST(String variable, int register) {
        addInstruction("st", variable, Assignment2Codegen.addR(register));
    }

    public void addBooleanOp(String op, int rStore, int r1, int r2){
        code.add("(");
        code.add(Assignment2Codegen.opMap.get(op));
        code.add(Assignment2Codegen.addR(rStore));
        code.add(Assignment2Codegen.addR(r1));
        code.add(Assignment2Codegen.addR(r2));
        code.add(")");
    }

    public void addBR(int register, int block1, int block2)
    {
        addInstruction("br", Assignment2Codegen.addR(register), Integer.toString(block1), Integer.toString(block2));
    }

    public int getCurrentRegister() {
        return currentRegister;
    }

    public int getNextRegister() {
        return currentRegister++;
    }
    public int getNumber() {
        return number;
    }

    public String toString() {
        return Assignment2Codegen.join(code, " ") + '\n';
    }

}
