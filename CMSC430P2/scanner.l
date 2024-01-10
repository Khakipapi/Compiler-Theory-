/*
Jose Reyes
UMGC 430
Project 2
September 7, 2023
*/
/* This file contains flex input file */

%{
#include <cstdio>
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws [ \t\r]+
comment ("//"|"--").*\n
real {digit}+\.{digit}*([Ee][+-]?{digit}+)?
bool (true|false)
line [\n]
digit [0-9]
relop ((\/?=|[><]?=<?)|([><]))
id [A-Za-z][A-Za-z_0-9]*
int {digit}+
punc [\(\),:;]

%%


{ws} { ECHO; }
{bool} { ECHO; return(BOOL_LITERAL); }
{real} { ECHO; return(REAL_LITERAL); }
{comment} { ECHO; nextLine();}
{line} { ECHO; nextLine();}
{relop} { ECHO; return(RELOP); }
"<"		{ ECHO; return(RELOP); }
"="     { ECHO; return(RELOP); }
"/="    { ECHO; return(RELOP); }
">"     { ECHO; return(RELOP); }
">="    { ECHO; return(RELOP); }
"<="    { ECHO; return(RELOP); }
"+"		{ ECHO; return(ADDOP); }
"-"     { ECHO; return(ADDOP); }
"/"     { ECHO; return(MULOP); }
"*"		{ ECHO; return(MULOP); }
"=>"    {ECHO; return(ARROW);}
"rem"     { return REMOP; }
"**"    {ECHO; return(EXPOP);}
begin { ECHO; return(BEGIN_); }
boolean { ECHO; return(BOOLEAN); }
end { ECHO; return(END); }
endreduce { ECHO; return(ENDREDUCE); }
function { ECHO; return(FUNCTION); }
integer { ECHO; return(INTEGER); }
is { ECHO; return(IS); }
reduce { ECHO; return REDUCE; }
returns { ECHO; return(RETURNS); }
and { ECHO; return(ANDOP); }
case { ECHO; return(CASE); }
else { ECHO; return(ELSE); }
endcase { ECHO; return(ENDCASE); }
endif { ECHO; return(ENDIF); }
if { ECHO; return(IF); }
others { ECHO; return(OTHERS); }
real { ECHO; return(REAL); }
then { ECHO; return(THEN); }
when { ECHO; return(WHEN); }
or { ECHO; return(OROP); }
not { ECHO; return(NOTOP); }
{id} { ECHO; return(IDENTIFIER);}
{int} { ECHO; return(INT_LITERAL); }
{punc} { ECHO; return(yytext[0]); }

. { ECHO; appendError(LEXICAL, yytext); }

%%