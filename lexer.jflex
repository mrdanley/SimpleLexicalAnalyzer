/*
Sunghwan Son
Daniel Le
CS 411
Project 2
*/

/* User Code */
import java.io.*;
import java.util.*;
import java_cup.runtime.Symbol;

%%

/* Options and declarations */
%class Lexer
%public
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

%{
	//arraylist to store tokens for output
	List<String> output=new ArrayList();

	//trie array structure declarations
	public int [] SWITCH = new int[52];
	public int symbolMaxSize = 300;
	public char [] symbol = new char[symbolMaxSize];
	public int symbolTopPtr = -1;
	public int nextMaxSize = 300;
	public int [] next = new int[nextMaxSize];
%}
%init{
	for(int i=0;i<52;i++){
		SWITCH[i] = -1;
	}
	for(int i=0;i<symbolMaxSize;i++){
		symbol[i] = '*';
	}
	for(int i=0;i<nextMaxSize;i++){
		next[i] = -1;
	}
%init}
%{
	//trie array implementation
	public void trieInsert(String s){
		int index = -1;
		//getnextSymbol()
		char valueOfSymbol = s.charAt(++index);
		//find correct position in SWITCH array
		int switchPos = (int)valueOfSymbol;
		if(switchPos >= 97){
			switchPos = switchPos - 71;
		}else{
			switchPos = switchPos - 65;
		}//end find correct position
		int symbolPtrIndex = SWITCH[switchPos];
		if(symbolPtrIndex == -1){
			SWITCH[switchPos] = ++symbolTopPtr;
			createID(s, 1);
		}else{
			valueOfSymbol = s.charAt(++index);
			boolean exit = false;
			while(!exit){
				if(symbol[symbolPtrIndex] == valueOfSymbol){
					if(valueOfSymbol != '@'){
						symbolPtrIndex++;
						valueOfSymbol = s.charAt(++index);
					}else{
						exit = true;
					}
				}else{
					if(next[symbolPtrIndex] != -1){
						symbolPtrIndex = next[symbolPtrIndex];
					}else{
						next[symbolPtrIndex] = ++symbolTopPtr;
						createID(s, index);
						exit = true;
					}
				}
			}
		}
	}
	//creates new identifiers
	public void createID(String s, int index){
		for(int i=index; i<s.length(); i++){
			symbol[symbolTopPtr] = s.charAt(i);
			//check symbol and next array size
			if(symbolTopPtr > symbolMaxSize*.8){
				doubleArrayMaxSizes();
			}
			//increment ptr for symbol if need
			if(i<s.length()-1){
				symbolTopPtr++;
			}
		}
	}
	public void doubleArrayMaxSizes(){
		symbolMaxSize*=2;
		nextMaxSize*=2;
		char [] tempSymbol = new char[symbolMaxSize];
		int [] tempNext = new int[nextMaxSize];
		for(int i=0;i<=symbolTopPtr;i++){
			tempSymbol[i] = symbol[i];
			tempNext[i] = next[i];
		}
		for(int i=symbolTopPtr+1;i<symbolMaxSize;i++){
			tempSymbol[i] = '*';
			tempNext[i] = -1;
		}
		symbol = tempSymbol;
		next = tempNext;
	}
%}

%eof{
	// Print tokens to screen
	System.out.println("output:");
	for(int i=0; i<output.size(); i++){
		System.out.print(output.get(i));
	}System.out.println("\n");

	/*
	// Print switch array to screen
	//capital letters
	System.out.print("       ");
	for(int i=0; i<26; i++){
	  System.out.print((char)(i+65)+"    ");
	}System.out.println();
	System.out.print("switch ");
	for(int i=0; i<26; i++){
	  if(SWITCH[i]>999){
	    System.out.print(SWITCH[i]+" ");
	  }else if(SWITCH[i]>99){
	    System.out.print(SWITCH[i]+"  ");
	  }else if(SWITCH[i]>9 || SWITCH[i]==-1){
	    System.out.print(SWITCH[i]+"   ");
	  }else{//SWITCH[i]<=9
	    System.out.print(SWITCH[i]+"    ");
	  }
	}System.out.println();

	//lowercase letters
	System.out.print("       ");
	for(int i=0; i<26; i++){
	  System.out.print((char)(i+97)+"    ");
	}System.out.println();
	System.out.print("SWITCH ");
	for(int i=26; i<52; i++){
	  if(SWITCH[i]>999){
	    System.out.print(SWITCH[i]+" ");
	  }else if(SWITCH[i]>99){
	    System.out.print(SWITCH[i]+"  ");
	  }else if(SWITCH[i]>9 || SWITCH[i]==-1){
	    System.out.print(SWITCH[i]+"   ");
	  }else{//SWITCH[i]<=9
	    System.out.print(SWITCH[i]+"    ");
	  }
	}System.out.println("\n");

	//Print symbol and next arrays to screen
	for(int j=0;j<symbolMaxSize;j+=20){
	  System.out.print("       ");
	  for(int i=j; i<j+20; i++){
	    if(i>999){
	      System.out.print(i+" ");
	    }else if(i>99){
	      System.out.print(i+"  ");
	    }else if(i>9 || i==-1){
	      System.out.print(i+"   ");
	    }else{//i<=9
	      System.out.print(i+"    ");
	    }
	  }System.out.println();
	  System.out.print("symbol ");
	  for(int i=j; i<j+20; i++){
	    System.out.print(symbol[i]+"    ");
	  }System.out.println();
	  System.out.print("next   ");
	  for(int i=j; i<j+20; i++){
	    if(next[i]>999){
	      System.out.print(next[i]+" ");
	    }else if(next[i]>99){
	      System.out.print(next[i]+"  ");
	    }else if(next[i]>9 || next[i]==-1){
	      System.out.print(next[i]+"   ");
	    }else{//next[i]<=9
	      System.out.print(next[i]+"    ");
	    }
	  }System.out.println("\n");
	}
	*/
%eof}


letter = [a-zA-Z]
digit = [0-9]
ws = [ \t\r]+
id = {letter}({letter} | [_0-9])*
integerconstant = {decimal} | {hexadecimal}
decimal = {digit}+
hexadecimal = 0[Xx][0-9A-Fa-f]+
doubleconstant = {digit}+\.{digit}* ([Ee][+-]?{digit}+)?
stringconstant = \".*\"

/* comments */
Comment = {TraditionalComment} | {OneLineComment}
OneLineComment = "//".*
TraditionalComment ="/*" .~ "*/" | "/*" [^("*/")]* //Z

%%
/* Lexical Rules */

"boolean"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_BOOLEAN);}
"else"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_ELSE);}
"implements"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_IMPLEMENTS);}
"println"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_PRINTLN);}
"void"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_VOID);}
"*"    	{output.add("multiplication "); return symbol(sym.t_MULTIPLICATION);}
"<="	{output.add("lessequal "); return symbol(sym.t_LESSEQUAL);}
"!="	{output.add("notequal "); return symbol(sym.t_NOTEQUAL);}
"="	{output.add("assignop "); return symbol(sym.t_ASSIGNOP);}
"("	{output.add("leftparen "); return symbol(sym.t_LEFTPAREN);}
"{"	{output.add("leftbrace "); return symbol(sym.t_LEFTBRACE);}
{stringconstant}	{output.add("stringconstant "); return symbol(sym.t_STRINGCONSTANT);}
"break"    	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_BREAK);}
"extends"	{output.add(yytext()+" "); return symbol(sym.t_EXTENDS);}
"int" {output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_INT);}
"readln"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_READLN);}
"while"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_WHILE);}
"/"	{output.add("division "); return symbol(sym.t_DIVISION);}
">"	{output.add("greater "); return symbol(sym.t_GREATER);}
"&&"	{output.add("and "); return symbol(sym.t_AND);}
";"	{output.add("semicolon "); return symbol(sym.t_SEMICOLON);}
")"	{output.add("rightparen "); return symbol(sym.t_RIGHTPAREN);}
"}"	{output.add("rightbrace "); return symbol(sym.t_RIGHTBRACE);}
"+"	{output.add("plus "); return symbol(sym.t_PLUS);}
"%"	{output.add("mod "); return symbol(sym.t_MOD);}
">="	{output.add("greaterequal "); return symbol(sym.t_GREATEREQUAL);}
"||"	{output.add("or "); return symbol(sym.t_OR);}
","	{output.add("comma "); return symbol(sym.t_COMMA);}
"["	{output.add("leftbracket "); return symbol(sym.t_LEFTBRACKET);}
"if"	{output.add("if "); trieInsert(yytext()+"@"); return symbol(sym.t_IF);}
"[]"	{output.add("newarray "); trieInsert(yytext()+"@"); return symbol(sym.t_NEWARRAY);}
"string"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_STRING);}
"-"	{output.add("minus "); return symbol(sym.t_MINUS);}
"<"	{output.add("less "); return symbol(sym.t_LESS);}
"=="	{output.add("equal "); return symbol(sym.t_EQUAL);}
"!"	{output.add("not "); return symbol(sym.t_NOT);}
"."	{output.add("period "); return symbol(sym.t_PERIOD);}
"]"	{output.add("rightbracket "); return symbol(sym.t_RIGHTBRACKET);}
"true" {output.add("booleanconstant "); trieInsert(yytext()+"@"); return symbol(sym.t_BOOLEANCONSTANT);}
"false"   {output.add("booleanconstant "); trieInsert(yytext()+"@"); return symbol(sym.t_BOOLEANCONSTANT);}
"class"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_CLASS);}
"for"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_FOR);}
"double"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_DOUBLE);}
"interface"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_INTERFACE);}
"return"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return symbol(sym.t_RETURN);}
{doubleconstant}	{output.add("doubleconstant "); return symbol(sym.t_DOUBLECONSTANT);}
{integerconstant}	{output.add("intconstant "); return symbol(sym.t_INTCONSTANT);}
{id}	{output.add("id "); trieInsert(yytext()+"@"); return symbol(sym.t_ID);}
{ws}	{/*Do Nothing*/}
\n {output.add("\n");}
{Comment}	{/*Do Nothing*/}

/* escape sequences */
"\\b"           { }
"\\t"           { }
"\\n"           { }
"\\f"           { }
"\\r"           { }
"\\\""          { }
"\\'"           { }
"\\\\"          { }
<<EOF>> {return symbol(sym.EOF);}
.    	{/*Do Nothing*/}
