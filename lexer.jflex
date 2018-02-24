/*
Sunghwan Son
Daniel Le
CS 411
Project 1
*/

/* User Code */
import java.io.*;
import java.util.*;

%%
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

	//token integer declarations
	public int t_BOOLEAN = 1001;
	public int t_ELSE= 1002;
	public int t_IMPLEMENTS= 1003;
	public int t_PRINTLN= 1004;
	public int t_VOID= 1005;
	public int t_MULTIPLICATION= 1006;
	public int t_LESSEQUAL= 1007;
	public int t_NOTEQUAL= 1008;
	public int t_ASSIGNOP = 1009;
	public int t_LEFTPAREN = 1010;
	public int t_LEFTBRACE = 1011;
	public int t_STRINGCONSTANT = 1012;
	public int t_BREAK = 1013;
	public int t_EXTENDS = 1014;
	public int t_INT = 1015;
	public int t_READLN = 1016;
	public int t_WHILE = 1017;
	public int t_DIVISION = 1018;
	public int t_GREATER = 1019;
	public int t_AND = 1020;
	public int t_SEMICOLON = 1021;
	public int t_RIGHTPAREN = 1022;
	public int t_RIGHTBRACE = 1023;
	public int t_BOOLEANCONSTANT = 1024;
	public int t_CLASS = 1025;
	public int t_FOR = 1026;
	public int t_INTERFACE = 1027;
	public int t_RETURN = 1028;
	public int t_PLUS = 1029;
	public int t_MOD = 1030;
	public int t_GREATEREQUAL = 1031;
	public int t_OR = 1032;
	public int t_COMMA = 1033;
	public int t_LEFTBRACKET = 1034;
	public int t_INTCONSTANT = 1035;
	public int t_ID = 1036;
	public int t_DOUBLE = 1037;
	public int t_IF = 1038;
	public int t_NEWARRAY = 1039;
	public int t_STRING = 1040;
	public int t_MINUS = 1041;
	public int t_LESS = 1042;
	public int t_EQUAL = 1043;
	public int t_NOT = 1044;
	public int t_PERIOD = 1045;
	public int t_RIGHTBRACKET = 1046;
	public int t_DOUBLECONSTANT = 1047;
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
%eof}


/* Options and declarations */
%class lexer
%public
%standalone
letter = [a-zA-Z]
digit = [0-9]
ws = [ \t]+
id = [A-Za-z][A-Za-z_0-9]*
integerconstant = {decimal} | {hexadecimal}
decimal = {digit}+
hexadecimal = 0[Xx][0-9A-Fa-f]+
doubleconstant = {digit}+\.{digit}* ([Ee][+-]?{digit}+)?
stringconstant = \".*\"

/* comments */
Comment = {TraditionalComment} | {OneLineComment}
OneLineComment = "//".*
TraditionalComment ="/*" .~ "*/" | "/*"[^("*/")]*//Z

%%
/* Lexical Rules */

"boolean"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_BOOLEAN; }
"else"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_ELSE;}
"implements"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_IMPLEMENTS;}
"println"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_PRINTLN;}
"void"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_VOID;}
"*"    	{output.add("multiplication "); return t_MULTIPLICATION;}
"<="	{output.add("lessequal "); return t_LESSEQUAL;}
"!="	{output.add("notequal "); return t_NOTEQUAL;}
"="	{output.add("assignop "); return t_EQUAL;}
"("	{output.add("leftparen "); return t_LEFTPAREN;}
"{"	{output.add("leftbrace "); return t_RIGHTBRACE; }
{stringconstant}	{output.add("stringconstant "); return t_STRINGCONSTANT; }
"break"    	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_BREAK;}
"extends"	{output.add(yytext()+" "); return t_EXTENDS;}
"int" {output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_INT;}
"readln"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_READLN;}
"while"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_WHILE;}
"/"	{output.add("division "); return t_DIVISION;}
">"	{output.add("greater "); return t_GREATER;}
"&&"	{output.add("and "); return t_AND;}
";"	{output.add("semicolon "); return t_SEMICOLON;}
")"	{output.add("rightparen "); return t_RIGHTPAREN;}
"}"	{output.add("rightbrace "); return t_RIGHTBRACE;}
"+"	{output.add("plus "); return t_PLUS;}
"%"	{output.add("mod "); return t_MOD;}
">="	{output.add("greaterequal "); return t_GREATEREQUAL;}
"||"	{output.add("or "); return t_OR;}
","	{output.add("comma "); return t_COMMA;}
"["	{output.add("leftbracket "); return t_LEFTBRACKET;}
"if"	{output.add("if "); trieInsert(yytext()+"@"); return t_IF;}
"[]"	{output.add("newarray "); trieInsert(yytext()+"@"); return t_NEWARRAY;}
"string"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_STRING;}
"-"	{output.add("minus "); return t_MINUS;}
"<"	{output.add("less "); return t_LESS;}
"=="	{output.add("equal "); return t_EQUAL;}
"!"	{output.add("not "); return t_NOT;}
"."	{output.add("period "); return t_PERIOD;}
"]"	{output.add("rightbracket "); return t_RIGHTBRACKET;}
"true" {output.add("booleanconstant "); trieInsert(yytext()+"@"); return t_BOOLEANCONSTANT;}
"false"   {output.add("booleanconstant "); trieInsert(yytext()+"@"); return t_BOOLEANCONSTANT;}
"class"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_CLASS;}
"for"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_FOR;}
"double"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_DOUBLE;}
"interface"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_INTERFACE;}
"return"	{output.add(yytext()+" "); trieInsert(yytext()+"@"); return t_RETURN;}
{doubleconstant}	{output.add("doubleconstant "); return t_DOUBLECONSTANT;}
{integerconstant}	{output.add("intconstant "); return t_INTCONSTANT;}
{id}	{output.add("id "); trieInsert(yytext()+"@"); return t_ID;}
{ws}	{/*Do Nothing*/}
\n {output.add("\n");}
{Comment}	{/*Do Nothing*/}
.    	{/*Do Nothing*/}
