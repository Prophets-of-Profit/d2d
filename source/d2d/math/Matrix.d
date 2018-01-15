module d2d.math.Matrix;

import std.array;

/**
 * A matrix is just like a mathematical matrix where it is similar to essentially a 2d array of of the given type
 * Template parameters are the type, how many rows, and how many columns
 */
class Matrix(T, ulong rows, ulong columns) {

    T[][] elements; ///The elements of the matrix; stored as an array of rows (i.e. row vectors)

    /**
     * Recursively finds the determinant of the matrix if the matrix is square
     * Task is done in O(n!) for an nxn matrix, so determinants of matrices of at most size 3x3 are already defined to be more efficient
     * Not very efficient for large matrices 
     */
    static if(rows == columns) {
        @property T determinant() {
            //Degenerate cases:
            if(rows == 1) { return elements.front.front; }
            else if(rows == 2) { return elements[0][0] * elements[1][1] - elements[0][1] * elements[1][0]; }
            else if(rows == 3) { 
                return elements[0][0] * elements[1][1] * elements[2][2]
                        + elements[0][1] * elements[1][2] * elements[2][0]
                        + elements[0][2] * elements[1][0] * elements[2][1]
                        - elements[0][2] * elements[1][1] * elements[2][0]
                        - elements[0][1] * elements[1][0] * elements[2][2]
                        - elements[0][0] * elements[1][2] * elements[2][1];
            }
            T determinant;
            foreach(i; 0..columns) {
                determinant += -1.pow(i) * this.elements[0][i] * 
                (minors[0] = new Matrix!(T, rows - 1, columns - 1)(
                    this.elements[1..$].map!(
                        a => a[0..i] ~ a[i + 1..$]
                    )
                ).determinant);
            }
            return determinant;
        }
    }
    
    /**
     * Constructs a matrix from a two-dimensional array of elements
     */
    this(T[][] elements) {
        this.elements = elements;
    }

    /**
     * Allows assigning the matrix to a static two-dimensional array to set all components of the vector
     */
    void opAssign(T[][] rhs) {
        this.elements = rhs;
    }

    /**
     * Allows assigning the matrix to a single value to set all elements of the vector to such a value
     */
    void opAssign(T rhs) {
        foreach (i; 0..this.elements.length) {
            foreach(element; this.elements[i].parallel){
                element = rhs;
            }
        }
    }

}
