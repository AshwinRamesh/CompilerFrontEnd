//tutorial 2 on antlr
grammar Expr;

//BIG PLAYS

//at the start of the parser's run
@parser::header {
    import java.util.HashMap;
}

//define some variables, locals is a keyword
program locals [HashMap<String,Integer> values = new HashMap<String,Integer>()]: statement { 
    System.out.println($values.toString());
};

statement : 
    statement ';' statement
    | IDENT ':=' expr {$program::values.put($IDENT.text, $expr.value);}
    | '';
//in the [] is LITERALLY java
expr returns [int value]:left=expr '*' right=expr {$expr.value = $left.value * $right.value;} //similar for others
    | left=expr '/' right=expr {$expr.value = $left.value / $right.value;} 
    | left=expr '+' right=expr {$expr.value = $left.value + $right.value;} 
    | left=expr '-' right=expr {$expr.value = $left.value - $right.value;} 
    | IDENT {$expr.value = $program::values.get($IDENT.text);}
    | NUM {$expr.value = $NUM.int;};
    //| NUM {System.out.println($NUM.int);}; // LITERALLY java (can also do .text}
//in the {} is an 'action' and LITERALLY java
WS: [ \t\r\n]+ -> skip;
IDENT: ('a'..'z')+;
NUM: ('0'..'9')+;




