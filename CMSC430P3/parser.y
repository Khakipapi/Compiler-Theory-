/* Jose Reyes
  9/26/2023
   Definition: A parse tree grammar is a formal representation of the syntax rules of a programming language or a formal language.
   It describes the hierarchical structure of valid sentences or expressions in the language, using a tree-like structure called a parse tree.
   The parse tree represents the syntactic structure of a given sentence or expression, with each node in the tree corresponding to a syntactic unit
*/

%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <math.h>


using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"
#include "stdlib.h"
#include <stdio.h>
#include <cmath>

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}
int yylex();

Symbols<double> symbols;

double result;
double * params;
int intermediate_statement;
int inherited_case_expression_value;

%}

%define parse.error verbose

%union
{
    char* iden;  // Changing CharPtr to char* for clarity
    Operators oper;
    double value;
}



%token <iden> IDENTIFIER
%token <value> INT_LITERAL REAL_LITERAL BOOL_LITERAL CASE TRUE FALSE
%token <oper> ADDOP MULOP RELOP OROP  REMOP EXPOP NOTOP
%token ANDOP
%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token THEN WHEN
%token  ELSE ENDCASE ENDIF IF OTHERS REAL ARROW

%type <value> body statement_ statement reductions unary exponent expression binary relation term
	factor primary case cases optional_variable

%type <oper> operator


%%

function:
	function_header optional_variable body {result = $3;} ;

function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable:
	optional_variable variable |
	error ';' { $$ = 0; }
 |
	%empty { $$ = 0; };  // Explicitly set $$ to 0


variable:
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

parameters:
	parameter optional_parameter;

optional_parameter:
	optional_parameter ',' parameter |
	%empty

parameter:
	IDENTIFIER ':' type {symbols.insert($1, params[0]);} ;


type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

statement_:
     statement ';' { intermediate_statement = $1; }
        |
        error ';' { $$ = NAN; };


statement:
 	expression |
 	REDUCE operator reductions ENDREDUCE { $$ = $3; } |
     IF expression THEN statement_ ELSE statement_ ENDIF
     { $$ = ($2) ? $4 : $6; }|

CASE expression IS cases OTHERS ARROW statement_ ENDCASE
{
    inherited_case_expression_value = $2;
    if (!isnan($4)) {
        $$ = $4;
    } else {
        $$ = $7;
    }
}



cases:
    cases case
    {
        $$ = isnan($1) ? $2 : $1;
    }
    |
    %empty
    {
        $$ = NAN;
    }
    ;

case:
    WHEN INT_LITERAL ARROW statement_
    {
        $$ = (inherited_case_expression_value == $2) ? $4 : NAN;
    }
    ;


operator:
	ADDOP |
	RELOP |
	EXPOP |
	MULOP ;

reductions:
    reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
    %empty { $$ = 0; };

expression:
    expression OROP binary {$$ = evaluateLogical($1, $2, $3);} |
    binary;

binary:
    binary ANDOP relation {$$ = evaluateLogical($1, AND, $3);}|
    relation ;

relation:
    relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
    term ;


term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;

factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP exponent { $$ = (int)$1 % (int)$3; } |
	exponent ;

exponent:
	unary |
	unary  EXPOP exponent { $$=pow($1,$3); } ;


unary:
	NOTOP primary {$$ = !$2;}|
	primary;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL { $$ = $1; }|
	IDENTIFIER { double temp; if (!symbols.find($1, temp)) appendError(UNDECLARED, $1); $$ = temp; } ;



%%



int main(int argc, char *argv[]) {


    params = new double[argc - 1];
    for (int i = 1; i < argc; i++)
        params[i - 1] = atof(argv[i]);

    // Parsing
    firstLine();
    yyparse();

    // Existing termination code
    if (lastLine() == 0)
        cout << "Result = " << result << endl;

    return 0;
}
