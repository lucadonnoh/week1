pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom"; // hint: you can use more than one templates in circomlib-matrix to help you
include "../../node_modules/circomlib/circuits/gates.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component Ax = matMul(n, n, 1);
    for(var j = 0; j < n; j++) {
        for(var k = 0; k < n; k++) {
            Ax.a[j][k] <== A[j][k];
        }
        Ax.b[j][0] <== x[j];
    }

    component is_eq[n];
    for(var i = 0; i < n; i++) {
        is_eq[i] = IsEqual();
        is_eq[i].in[0] <== Ax.out[i][0];
        is_eq[i].in[1] <== b[i];
    }

    component and[n-1];
    and[0] = AND();
    and[0].a <== is_eq[0].out;
    and[0].b <== is_eq[1].out;

    for(var i = 2; i < n; i++) {
        and[i-1] = AND();
        and[i-1].a <== and[i-2].out;
        and[i-1].b <== is_eq[i].out;
    }

    out <== and[n-2].out;
}

component main {public [A, b]} = SystemOfEquations(3);