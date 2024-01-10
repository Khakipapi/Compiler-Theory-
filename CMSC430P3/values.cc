/* Jose Reyes
	9/26/2023
	Project 3
	The present document encompasses the evaluation functions' bodies.
*/
#include <string>
#include <vector>
#include <cmath>
#include <stdexcept>


using namespace std;

#include "values.h"
#include "listing.h"
#include <iostream>

double evaluateReduction(Operators operator_, double head, double tail)
{
    if (operator_ == ADD)
        return head + tail;
    return head * tail;
}

bool evaluateRelational(double left, Operators operator_, double right)
{
    bool result;
    switch (operator_)
    {
        case LESS:
            result = left < right;
            break;
        case GREATER:
            result = left > right;
            break;
        case EQUAL:
            result = (left == right);  // Changed to equality comparison
            break;
        case UNEQUAL:
            result = (left != right);  // Changed to inequality comparison
            break;
        case LESS_EQUAL:
            result = left <= right;
            break;
        case GR_EQUAL:
            result = left >= right;
            break;
    }
    return result;
}




double evaluateArithmetic(double left, Operators operator_, double right)
{
    double result;
    switch (operator_)
    {
        case ADD:
            result = left + right;
            break;
        case SUBTRACT:
            result = left - right;
            break;
        case MULTIPLY:
            result = left * right;
            break;
        case DIVIDE:
            if (right != 0)
                result = left / right;
            else
                throw runtime_error("Division by zero");
            break;

        case REM:
            result= fmod(left, right);
            break;
        case POWER:
            result = pow(left, right);
            break;


    }
    return result;
}




bool evaluateLogical(bool left, Operators operator_, bool right) {
    // Initialize the result variable to false
    bool result = false;

    // Use a switch statement to check which operator we're dealing with
    switch (operator_) {
        case AND: // If the operator is AND
            result = left && right;
            break;

        case OR: // If the operator is OR
            result = left || right;
            break;


        default:

            break;
    }

    return result; // Return the computed result
}

