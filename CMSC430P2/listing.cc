// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produces the compilation
// listing
/*
Jose Reyes
UMGC 430
Project 2
listing.cc
September 7, 2023
*/

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors = 0;
static int syntacticErrors = 0;
static int semanticErrors = 0;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");

    if (totalErrors == 0){
        printf("%s\n", "Compiled Successfully");
    } else{
        printf("%s","Lexical Errors = ");
        printf("%i\n",lexicalErrors );
        printf("%s","Syntax Errors = ");
        printf("%i\n",syntacticErrors );
        printf("%s","Semantic Errors = ");
        printf("%i\n",semanticErrors );


    }
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;
    if(errorCategory == 0){
        lexicalErrors++;
    }
    if(errorCategory == 1){
        syntacticErrors++;
    }
    if(errorCategory == 2|errorCategory == 3|errorCategory == 4){
        semanticErrors++;
    }
	totalErrors++;
}

void displayErrors()
{
	if (error != "")
		printf("%s\n", error.c_str());
	error = "";
}
