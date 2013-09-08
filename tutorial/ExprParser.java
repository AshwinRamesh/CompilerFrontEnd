// Generated from Expr.g by ANTLR 4.1

    import java.util.HashMap;

import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class ExprParser extends Parser {
	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__6=1, T__5=2, T__4=3, T__3=4, T__2=5, T__1=6, T__0=7, WS=8, IDENT=9, 
		NUM=10;
	public static final String[] tokenNames = {
		"<INVALID>", "':='", "'+'", "'*'", "'-'", "''", "'/'", "';'", "WS", "IDENT", 
		"NUM"
	};
	public static final int
		RULE_program = 0, RULE_statement = 1, RULE_expr = 2;
	public static final String[] ruleNames = {
		"program", "statement", "expr"
	};

	@Override
	public String getGrammarFileName() { return "Expr.g"; }

	@Override
	public String[] getTokenNames() { return tokenNames; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public ExprParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class ProgramContext extends ParserRuleContext {
		public HashMap<String,Integer> values = new HashMap<String,Integer>();
		public StatementContext statement() {
			return getRuleContext(StatementContext.class,0);
		}
		public ProgramContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_program; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ExprListener ) ((ExprListener)listener).enterProgram(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ExprListener ) ((ExprListener)listener).exitProgram(this);
		}
	}

	public final ProgramContext program() throws RecognitionException {
		ProgramContext _localctx = new ProgramContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_program);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(6); statement(0);
			 System.out.println(_localctx.values.toString()); 
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StatementContext extends ParserRuleContext {
		public int _p;
		public Token IDENT;
		public ExprContext expr;
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public ExprContext expr() {
			return getRuleContext(ExprContext.class,0);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public TerminalNode IDENT() { return getToken(ExprParser.IDENT, 0); }
		public StatementContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public StatementContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ExprListener ) ((ExprListener)listener).enterStatement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ExprListener ) ((ExprListener)listener).exitStatement(this);
		}
	}

	public final StatementContext statement(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		StatementContext _localctx = new StatementContext(_ctx, _parentState, _p);
		StatementContext _prevctx = _localctx;
		int _startState = 2;
		enterRecursionRule(_localctx, RULE_statement);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(16);
			switch (_input.LA(1)) {
			case IDENT:
				{
				setState(10); ((StatementContext)_localctx).IDENT = match(IDENT);
				setState(11); match(1);
				setState(12); ((StatementContext)_localctx).expr = expr(0);
				((ProgramContext)getInvokingContext(0)).values.put((((StatementContext)_localctx).IDENT!=null?((StatementContext)_localctx).IDENT.getText():null), ((StatementContext)_localctx).expr.value);
				}
				break;
			case 5:
				{
				setState(15); match(5);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(23);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,1,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					{
					_localctx = new StatementContext(_parentctx, _parentState, _p);
					pushNewRecursionContext(_localctx, _startState, RULE_statement);
					setState(18);
					if (!(3 >= _localctx._p)) throw new FailedPredicateException(this, "3 >= $_p");
					setState(19); match(7);
					setState(20); statement(4);
					}
					} 
				}
				setState(25);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,1,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class ExprContext extends ParserRuleContext {
		public int _p;
		public int value;
		public ExprContext left;
		public Token IDENT;
		public Token NUM;
		public ExprContext right;
		public ExprContext expr;
		public List<ExprContext> expr() {
			return getRuleContexts(ExprContext.class);
		}
		public ExprContext expr(int i) {
			return getRuleContext(ExprContext.class,i);
		}
		public TerminalNode IDENT() { return getToken(ExprParser.IDENT, 0); }
		public TerminalNode NUM() { return getToken(ExprParser.NUM, 0); }
		public ExprContext(ParserRuleContext parent, int invokingState) { super(parent, invokingState); }
		public ExprContext(ParserRuleContext parent, int invokingState, int _p) {
			super(parent, invokingState);
			this._p = _p;
		}
		@Override public int getRuleIndex() { return RULE_expr; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof ExprListener ) ((ExprListener)listener).enterExpr(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof ExprListener ) ((ExprListener)listener).exitExpr(this);
		}
	}

	public final ExprContext expr(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExprContext _localctx = new ExprContext(_ctx, _parentState, _p);
		ExprContext _prevctx = _localctx;
		int _startState = 4;
		enterRecursionRule(_localctx, RULE_expr);
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(31);
			switch (_input.LA(1)) {
			case IDENT:
				{
				setState(27); ((ExprContext)_localctx).IDENT = match(IDENT);
				_localctx.value = ((ProgramContext)getInvokingContext(0)).values.get((((ExprContext)_localctx).IDENT!=null?((ExprContext)_localctx).IDENT.getText():null));
				}
				break;
			case NUM:
				{
				setState(29); ((ExprContext)_localctx).NUM = match(NUM);
				_localctx.value = (((ExprContext)_localctx).NUM!=null?Integer.valueOf(((ExprContext)_localctx).NUM.getText()):0);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			_ctx.stop = _input.LT(-1);
			setState(55);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			while ( _alt!=2 && _alt!=-1 ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(53);
					switch ( getInterpreter().adaptivePredict(_input,3,_ctx) ) {
					case 1:
						{
						_localctx = new ExprContext(_parentctx, _parentState, _p);
						_localctx.left = _prevctx;
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(33);
						if (!(6 >= _localctx._p)) throw new FailedPredicateException(this, "6 >= $_p");
						setState(34); match(3);
						setState(35); ((ExprContext)_localctx).right = ((ExprContext)_localctx).expr = expr(7);
						_localctx.value = ((ExprContext)_localctx).left.value * ((ExprContext)_localctx).right.value;
						}
						break;

					case 2:
						{
						_localctx = new ExprContext(_parentctx, _parentState, _p);
						_localctx.left = _prevctx;
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(38);
						if (!(5 >= _localctx._p)) throw new FailedPredicateException(this, "5 >= $_p");
						setState(39); match(6);
						setState(40); ((ExprContext)_localctx).right = ((ExprContext)_localctx).expr = expr(6);
						_localctx.value = ((ExprContext)_localctx).left.value / ((ExprContext)_localctx).right.value;
						}
						break;

					case 3:
						{
						_localctx = new ExprContext(_parentctx, _parentState, _p);
						_localctx.left = _prevctx;
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(43);
						if (!(4 >= _localctx._p)) throw new FailedPredicateException(this, "4 >= $_p");
						setState(44); match(2);
						setState(45); ((ExprContext)_localctx).right = ((ExprContext)_localctx).expr = expr(5);
						_localctx.value = ((ExprContext)_localctx).left.value + ((ExprContext)_localctx).right.value;
						}
						break;

					case 4:
						{
						_localctx = new ExprContext(_parentctx, _parentState, _p);
						_localctx.left = _prevctx;
						pushNewRecursionContext(_localctx, _startState, RULE_expr);
						setState(48);
						if (!(3 >= _localctx._p)) throw new FailedPredicateException(this, "3 >= $_p");
						setState(49); match(4);
						setState(50); ((ExprContext)_localctx).right = ((ExprContext)_localctx).expr = expr(4);
						_localctx.value = ((ExprContext)_localctx).left.value - ((ExprContext)_localctx).right.value;
						}
						break;
					}
					} 
				}
				setState(57);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,4,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 1: return statement_sempred((StatementContext)_localctx, predIndex);

		case 2: return expr_sempred((ExprContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean statement_sempred(StatementContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0: return 3 >= _localctx._p;
		}
		return true;
	}
	private boolean expr_sempred(ExprContext _localctx, int predIndex) {
		switch (predIndex) {
		case 1: return 6 >= _localctx._p;

		case 2: return 5 >= _localctx._p;

		case 3: return 4 >= _localctx._p;

		case 4: return 3 >= _localctx._p;
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\uacf5\uee8c\u4f5d\u8b0d\u4a45\u78bd\u1b2f\u3378\3\f=\4\2\t\2\4\3\t"+
		"\3\4\4\t\4\3\2\3\2\3\2\3\3\3\3\3\3\3\3\3\3\3\3\3\3\5\3\23\n\3\3\3\3\3"+
		"\3\3\7\3\30\n\3\f\3\16\3\33\13\3\3\4\3\4\3\4\3\4\3\4\5\4\"\n\4\3\4\3\4"+
		"\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3\4\3"+
		"\4\7\48\n\4\f\4\16\4;\13\4\3\4\2\5\2\4\6\2\2@\2\b\3\2\2\2\4\22\3\2\2\2"+
		"\6!\3\2\2\2\b\t\5\4\3\2\t\n\b\2\1\2\n\3\3\2\2\2\13\f\b\3\1\2\f\r\7\13"+
		"\2\2\r\16\7\3\2\2\16\17\5\6\4\2\17\20\b\3\1\2\20\23\3\2\2\2\21\23\7\7"+
		"\2\2\22\13\3\2\2\2\22\21\3\2\2\2\23\31\3\2\2\2\24\25\6\3\2\3\25\26\7\t"+
		"\2\2\26\30\5\4\3\2\27\24\3\2\2\2\30\33\3\2\2\2\31\27\3\2\2\2\31\32\3\2"+
		"\2\2\32\5\3\2\2\2\33\31\3\2\2\2\34\35\b\4\1\2\35\36\7\13\2\2\36\"\b\4"+
		"\1\2\37 \7\f\2\2 \"\b\4\1\2!\34\3\2\2\2!\37\3\2\2\2\"9\3\2\2\2#$\6\4\3"+
		"\3$%\7\5\2\2%&\5\6\4\2&\'\b\4\1\2\'8\3\2\2\2()\6\4\4\3)*\7\b\2\2*+\5\6"+
		"\4\2+,\b\4\1\2,8\3\2\2\2-.\6\4\5\3./\7\4\2\2/\60\5\6\4\2\60\61\b\4\1\2"+
		"\618\3\2\2\2\62\63\6\4\6\3\63\64\7\6\2\2\64\65\5\6\4\2\65\66\b\4\1\2\66"+
		"8\3\2\2\2\67#\3\2\2\2\67(\3\2\2\2\67-\3\2\2\2\67\62\3\2\2\28;\3\2\2\2"+
		"9\67\3\2\2\29:\3\2\2\2:\7\3\2\2\2;9\3\2\2\2\7\22\31!\679";
	public static final ATN _ATN =
		ATNSimulator.deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}