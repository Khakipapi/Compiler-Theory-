// CMSC 430
// Dr. Duane J. Jarc

// This file contains the function prototypes for the functions that produce the // compilation listing
/*
Jose Reyes
UMGC 430
Project 2
September 7, 2023
*/

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

