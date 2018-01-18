module d2d.math.Matrix;

import std.algorithm;
import std.array;
import std.math;
import std.parallelism;
import d2d.math;

/**
 * A matrix is just like a mathematical matrix where it is similar to essentially a 2d array of of the given type
 * Template parameters are the type, how many rows, and how many columns
 * TODO: static arrays
 * TODO: parallelism
 */
class Matrix(T, ulong rows, ulong columns) {

    T[rows][columns] elements; ///The elements of the matrix; stored as an array of rows (i.e. row vectors)

    /**
     * Recursively finds the determinant of the matrix if the matrix is square
     * Task is done in O(n!) for an nxn matrix, so determinants of matrices of at most size 3x3 are already defined to be more efficient
     * Not very efficient for large matrices 
     */
    static if(rows == columns) {
        @property T determinant() {
            //Degenerate cases:
            static if(rows == 1) { return elements.front.front; }
            else static if(rows == 2) { return elements[0][0] * elements[1][1] - elements[0][1] * elements[1][0]; }
            else static if(rows == 3) { 
                return elements[0][0] * elements[1][1] * elements[2][2]
                        + elements[0][1] * elements[1][2] * elements[2][0]
                        + elements[0][2] * elements[1][0] * elements[2][1]
                        - elements[0][2] * elements[1][1] * elements[2][0]
                        - elements[0][1] * elements[1][0] * elements[2][2]
                        - elements[0][0] * elements[1][2] * elements[2][1];
            } else {
                T determinant;
                foreach(i; 0..columns) {
                    determinant += (-1).pow(i) * this.elements[0][i] * 
                    (new Matrix!(T, rows - 1, columns - 1)(
                        this.elements[1..$].map!(
                            a => a[0..i] ~ a[i + 1..$]
                        ).array
                    ).determinant);
                }
                return determinant;
            }
        }
    }

    /**
     * Returns the nth row of the matrix
     */
    @property Vector!(T, columns) row(uint index)() {
        return new Vector!(T, columns)(this.elements[index]);
    }

    /**
     * Returns the nth column of the matrix
     */
    @property Vector!(T, rows) column(uint index)() {
        return new Vector(this.elements.map!(a => a[index]));
    }
    
    /**
     * Constructs a matrix from a two-dimensional array of elements
     */
    this(T[rows][columns] elements) {
        this.elements = elements;
    }

    /**
     * Constructs a matrix that is identically one value
     */
    this(T element) {
        foreach(i, ref item; (cast(T[][]) this.elements).parallel) {
            foreach(j, ref position; (cast(T[]) this.elements[i]).parallel) {
                position = element;
            }
        }
    }

    /**
     * Constructs a matrix as an identity matrix
     */
    this() {
        T[rows][columns] elements;
        foreach(index, ref element; (cast(T[]) elements).parallel) {
            elements[index][index] = 1;
        }
    }

    /**
     * Allows assigning the matrix to a static two-dimensional array to set all components of the matrix
     */
    void opAssign(T[rows][columns] rhs) {
        this.elements = rhs;
    }

    /**
     * Allows assigning the matrix to a single value to set all elements of the matrix to such a value
     */
    void opAssign(T rhs) {
        foreach(i, ref item; (cast(T[][]) this.elements).parallel) {
            foreach(j, ref position; (cast(T[]) this.elements[i]).parallel) {
                position = rhs;
            }
        }
    }

}
