/*
Jose Reyes
UMGC 430
Project 2
parser.y file containing the rules for the compiler
September 7, 2023
*/
%{

#include <string>
#include <vector>
#include <map>
#include <iostream>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);
Symbols<Types> symbols;
%}

%define parse.error verbose

%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL NOTOP CASE TRUE FALSE ELSE ENDIF IF
%token ADDOP MULOP RELOP ANDOP OROP REMOP EXPOP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token WHEN ARROW OTHERS ENDCASE THEN REAL

%type <type> type statement statement_ reductions expression relation term
	factor primary
%%

function:
    function_header optional_variable body ;

function_header:
    FUNCTION IDENTIFIER optional_parameters RETURNS type ';' ;

optional_variable:
    variable |
     ;

optional_parameters:
    optional_parameters ',' parameter |
    parameter |
     ;

variable:
	IDENTIFIER ':' type IS statement_
		{checkAssignment($3, $5, "Variable Initialization");
		symbols.insert($1, $3);} ;

parameter:
    IDENTIFIER ':' type ;

type:
	INTEGER {$$ = INT_TYPE;} |
	BOOLEAN {$$ = BOOL_TYPE;} |
    REAL {$$ = REAL_TYPE;};

body:
    BEGIN_ statement_ END ';' ;

statement_:
    statement ';' |
    error ';' {$$ = MISMATCH;} ;

statement:
    expression |
    REDUCE operator reductions ENDREDUCE {$$ = $3;}  |
    IF expression THEN statement_ ELSE statement_ ENDIF |
    CASE expression IS optional_cases OTHERS ARROW statement_ ENDCASE ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	{$$ = INT_TYPE;} ;

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
	expression ANDOP relation {$$ = checkLogical($1, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;


term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;


factor:
	factor MULOP primary  {$$ = checkArithmetic($1, $3);} |
	primary ;


primary:
    '(' expression ')' {$$ = $2;} |
    INT_LITERAL |
    REAL_LITERAL |
    BOOL_LITERAL |
    IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

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
