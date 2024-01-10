/* Jose Reyes
	9/26/2023
	Project 3
*/
%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment	\-\-.*\n
comment2	\/\/.*\n
line		[\n]
id		[A-Za-z](_?[A-Za-z0-9])*
digit [0-9]
int -?{digit}+
punc		[\(\),:;.]
real {digit}+[.]{digit}*([eE]?[+-]?{digit}+)?
%%

{ws}		{ ECHO;}
{comment}	{ ECHO; nextLine();}
{comment2}	{ECHO;nextLine();}
{line}		{ ECHO; nextLine();}
"=>"		{ECHO;  return(ARROW); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
"="		{ ECHO; yylval.oper = EQUAL; return(RELOP); }
"/="	{ ECHO; yylval.oper = UNEQUAL; return(RELOP); }
">="	{ ECHO; yylval.oper = GR_EQUAL; return(RELOP); }
"<="	{ ECHO; yylval.oper = LESS_EQUAL; return(RELOP); }
"+"     { ECHO; yylval.oper = ADD; return(ADDOP); }
"-"     { ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"     { ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"     { ECHO; yylval.oper = DIVIDE; return(MULOP); }
"**"	{ ECHO; yylval.oper = POWER; return(EXPOP); }
"%"		{ ECHO; yylval.oper = REM; return(REMOP); }
"!"     { ECHO; return(NOTOP); }

"true"  {
    ECHO;
    yylval.value = 1;  // Assign 1 to yylval.value to represent "true"
    return BOOL_LITERAL;  // Return the BOOL_LITERAL token
}

"false" {
    ECHO;
    yylval.value = 0;  // Assign 0 to yylval.value to represent "false"
    return BOOL_LITERAL;  // Return the BOOL_LITERAL token
}

[0-9]*"."[0-9]+ {
    yylval.value = atof(yytext); // Convert the string to float
    return REAL_LITERAL;
}
rem     { ECHO; yylval.oper = REM; return(REMOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
or    { ECHO; return(OROP); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
not   { ECHO; yylval.oper = NOT; return NOTOP; }
case		{ ECHO; return(CASE); }
else		{ ECHO; return(ELSE); }
endcase		{ ECHO; return(ENDCASE); }
endif		{ ECHO; return(ENDIF); }
if			{ ECHO; return(IF); }
others		{ ECHO; return(OTHERS); }
real		{ ECHO; return(REAL); }
then		{ ECHO; return(THEN); }
when		{ ECHO; return(WHEN); }
and		{ ECHO; return(ANDOP); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext);
    printf("Lexer: Setting INT_LITERAL to %d\n", yylval.value);
    return(INT_LITERAL);
}

{punc}		{ ECHO; return(yytext[0]); }
{real} { ECHO; yylval.value = atof(yytext); return(REAL_LITERAL); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%