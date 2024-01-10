/* Jose Reyes
 * 9/26/2023
	Project 3
	The present file provides function definitions pertaining to the evaluation functions.
*/

typedef char* CharPtr;
enum Operators {LESS, ADD, SUBTRACT, DIVIDE, MULTIPLY, POWER, GREATER, EQUAL, UNEQUAL, GR_EQUAL, LESS_EQUAL, REM,
        NOT,OR, AND };

double evaluateReduction(Operators operator_, double head, double tail);
bool evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);
bool evaluateLogical(bool left, Operators operator_, bool right);

