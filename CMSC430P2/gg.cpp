

#include "gg.h"
#include "listing.h"
#include "parser.tab.h"
#include <iostream>
#include <vector>
#include <numeric>

using namespace std;

void test_program(int a, float b, bool c, int d, int e) {
    // Multiple variable declarations
    int myInt = a;
    float myFloat = b;
    bool myBool = c;
    int anotherInt = d;

    // Integer, Real, and Boolean literals
    int intLiteral = 10;
    float floatLiteral = 3.14;
    bool boolLiteral = true;

    // Every arithmetic operator: + - * / % **
    int arithmeticResult = myInt + intLiteral - (myInt * intLiteral) / (myInt) % anotherInt;
    float expoResult = pow(myFloat, 2); // ** equivalent in C++

    cout << "Arithmetic Result: " << arithmeticResult << endl;
    cout << "Exponential Result: " << expoResult << endl;

    // Every relational operator: = != > >= < <=
    if (myInt == intLiteral && myFloat != floatLiteral && myInt > 0 && myFloat >= 0.1 && myInt < 20 && myFloat <= 3.14) {
        cout << "All relational operators checked." << endl;
    }

    // Every logical operator: and or not
    if (myBool && boolLiteral || !myBool) {
        cout << "All logical operators checked." << endl;
    }

    // If statement
    if (myInt > 5) {
        cout << "If statement: myInt is greater than 5." << endl;
    } else {
        cout << "If statement: myInt is not greater than 5." << endl;
    }

    // Case statement
    switch (e) {
        case 1:
            cout << "Case statement: e is 1." << endl;
            break;
        case 2:
            cout << "Case statement: e is 2." << endl;
            break;
        default:
            cout << "Case statement: e is neither 1 nor 2." << endl;
            break;
    }

    // Reduce statement (std::accumulate as equivalent)
    std::vector<int> vec = {1, 2, 3, 4, 5};
    int sum = std::accumulate(vec.begin(), vec.end(), 0);
    cout << "Reduced sum: " << sum << endl;
}

int main() {
    // First set of parameters
    test_program(10, 3.0, true, 7, 1);
    // Second set of parameters
    test_program(1, 1.1, false, 3, 2);
    // Third set of parameters
    test_program(4, 5.0, true, 2, 3);
}

