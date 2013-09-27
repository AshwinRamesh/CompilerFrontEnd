import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class Assignment2ErrorListener extends BaseErrorListener {
	@Override
	public void syntaxError(Recognizer<?, ?> recognizer,
			Object offendingSymbol,
			int line, int charPositionInLine,
			String msg,
			RecognitionException e)
	{
		/*List<String> stack = ((Parser)recognizer).getRuleInvocationStack();
		Collections.reverse(stack);
		System.err.println("rule stack: "+stack);
		System.err.println("line "+line+":"+charPositionInLine+" at "+
		offendingSymbol+": "+msg);*/
		
		System.out.println("Syntax Error");
		System.exit(1); //don't throw the actual errors from our ANTLR program like RuntimeExceptions
	}
}
