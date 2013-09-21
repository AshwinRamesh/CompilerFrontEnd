import java.util.ArrayList;
class Assignment2Codegen {


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

    ArrayList<String> code;
    int number;

    public Block() {
        code = new ArrayList<String>();
        code.add("(");
    }

    public Block(int number) {
        code = new ArrayList<String>();
        this.number = number;
    }

    public void endBlock() {
        code.add(")");
    }



    public String toString() {
        return Assignment2Codegen.join(code, " ");
    }

}
