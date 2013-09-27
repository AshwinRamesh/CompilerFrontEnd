import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.FileInputStream;
import java.io.InputStream;

public class Assignment2 {
	public static void main(String[] args) throws Exception {
		String inputFile = null;
		if ( args.length>0 ) inputFile = args[0];
		InputStream is = System.in;
		if ( inputFile!=null ) is = new FileInputStream(inputFile);

		ANTLRInputStream input = new ANTLRInputStream(is);
		Assignment2Lexer lexer = new Assignment2Lexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);
		Assignment2Parser parser = new Assignment2Parser(tokens);
		parser.removeErrorListeners(); // remove ConsoleErrorListener
		parser.addErrorListener(new Assignment2ErrorListener()); // add ours
		ParseTree tree = parser.program();
		// System.out.println(tree.toStringTree(parser)); // print tree as text
	}
}

