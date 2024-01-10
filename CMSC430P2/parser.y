/*
Jose Reyes
UMGC 430
Project 2
parser.y file containing the rules for the compiler
September 7, 2023
*/
%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER INT_LITERAL REAL_LITERAL BOOL_LITERAL
%token ADDOP MULOP RELOP ANDOP OROP REMOP EXPOP NOTOP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS IF
%token CASE WHEN ARROW OTHERS ENDCASE ENDIF THEN ELSE REAL

%%

function:
    function_header optional_variable body ;

function_header:
    FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_variable:
    optional_variable variable |
     ;

optional_parameters:
    optional_parameters ',' parameter |
    parameter |
     ;

variable:
    IDENTIFIER ':' type IS statement_ ;

parameter:
    IDENTIFIER ':' type ;

type:
    INTEGER |
    BOOLEAN |
    REAL ;

body:
    BEGIN_ statement_ END ';' ;

statement_:
    statement ';' |
    error ';' ;

statement:
    expression |
    REDUCE operator reductions ENDREDUCE  |
    IF expression THEN statement_ ELSE statement_ ENDIF |
    CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE ;

reductions:
    reductions statement_ |
     ;

optional_cases:
    optional_cases case |
    ;

case:
    WHEN INT_LITERAL ARROW statement_ ;

operator:
    ADDOP |
    MULOP|
    REMOP|
    EXPOP;

expression:
    expression OROP and_expression |
    and_expression ;

and_expression:
    and_expression ANDOP not_expression |
    not_expression ;

not_expression:
    NOTOP not_expression |
    relation ;

relation:
    relation RELOP term |
    term ;

term:
    term ADDOP expo |
    term MULOP expo |
    term REMOP expo |
    expo ;

expo:
   factor  EXPOP expo |
    factor ;

factor:
    '(' expression ')' |
    INT_LITERAL |
    REAL_LITERAL |
    BOOL_LITERAL |
    IDENTIFIER ;

%%

void yyerror(const char* message)
{
    appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
    firstLine();
    yyparse();
    lastLine();
    return 0;
}
