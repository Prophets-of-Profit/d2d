/**
 * Matrix
 */
module d2d.math.Matrix;

import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.parallelism;
import d2d.math;

/**
 * A matrix is just like a mathematical matrix where it is similar to essentially a 2d array of of the given type
 * Template parameters are the type, how many rows, and how many columns
 * TODO:frustums, transformations, speed everything up with parallelism
 */
class Matrix(T, uint rows, uint columns) {

    T[columns][rows] elements; ///The elements of the matrix; stored as an array of rows (i.e. row vectors)

    alias elements this; //Allows for slicing and operating on the matrix as a 2d array

    /**
     * Recursively finds the determinant of the matrix if the matrix is square
     * Task is done in O(n!) for an nxn matrix, so determinants of matrices of at most size 3x3 are already defined to be more efficient
     * Not very efficient for large matrices 
     */
    static if (rows == columns) {
        @property T determinant() {
            //Degenerate cases:
            static if (rows == 1) {
                return elements.front.front;
            }
            else static if (rows == 2) {
                return elements[0][0] * elements[1][1] - elements[0][1] * elements[1][0];
            }
            else static if (rows == 3) {
                return elements[0][0] * elements[1][1] * elements[2][2]
                    + elements[0][1] * elements[1][2] * elements[2][0]
                    + elements[0][2] * elements[1][0] * elements[2][1]
                    - elements[0][2] * elements[1][1] * elements[2][0]
                    - elements[0][1] * elements[1][0] * elements[2][2]
                    - elements[0][0] * elements[1][2] * elements[2][1];
            }
            else {
                //Find the determinants of the sub-matrices
                T determinant;
                foreach (i; 0 .. columns) {
                    determinant += (-1).pow(i) * this.elements[0][i] * (new Matrix!(T,
                            rows - 1, columns - 1)(this.elements[1 .. $].map!(a => a[0 .. i] ~ a[i + 1 .. $])
                            .array).determinant);
                }
                return determinant;
            }
        }
    }

    /**
     * Returns the inverse of a square matrix, which should give the identity if they are multiplied.
     */
    static if (rows == columns) {
        @property Matrix!(T, rows, columns) inverse() {
            Matrix!(T, rows, 2 * columns) augmentedMatrix = this.augment!(T, rows, columns, columns)(new Matrix!(T, rows, columns));
            return augmentedMatrix.reducedRowEchelon.getSlice!(rows, columns)(0, columns);
        }
    }

    /**
     * Returns the matrix in row-echelon form
     * In row-echelon form, the diagonal elements are equal to one
     * and all elements below the diagonal are zero
     * This method uses the Gauss-Jordan algorithm, which has arithmetic complexity O(n^3)
     * Be wary of truncation for integer matrices
     */
    @property Matrix!(T, rows, columns) rowEchelon() {
        Matrix!(T, rows, columns) output = new Matrix!(T, rows, columns)(this);
        //The pivot coordinates
        uint i = 0; 
        uint j = 0;
        //If the i,j'th element is 0 swap to ensure that it is not
        //If the first column is zero instead move the pivot one to the right
        import std.stdio;

        while (i < rows && j < columns) {
            //Swap the row with the row that has the largest absolute jth value
            //This is done because dividing by small values may cause issues with precision
            swap(output[i], output[output.elements[i..rows].maxIndex!((T[columns] a, T[columns] b) => abs(a[j]) < abs(b[j])) + i]);
            //If the maximum is zero, then the entire column is equal to zero and we need to move the pointer right
            if (output[i][j] == 0) {
                j += 1;
            }
            //Makes the pivot entry equal to one
            output[i][] /= output[i][j];
            
            writeln("Output1-divide: ", output);
            //Set all elements below the pivot to zero
            foreach (row; i + 1 .. rows) {
                output[row][] -= output[i][] * output[row][j];
            }
            writeln("Output2-subtract: ", output);
            i += 1;
            j += 1;
        }
        return output;
    }

    /**
     * Returns the matrix in row-echelon form
     * In reduced row-echelon form, the diagonal elements are equal to one
     * and all elements below and above the diagonal are zero
     * This method uses the Gauss-Jordan algorithm, which has arithmetic complexity O(n^3)
     * Be wary of truncation for integer matrices
     */
    @property Matrix!(T, rows, columns) reducedRowEchelon() {
        Matrix!(T, rows, columns) output = new Matrix!(T, rows, columns)(this);
        //The pivot coordinates
        uint i = 0; 
        uint j = 0;
        //If the i,j'th element is 0 swap to ensure that it is not
        //If the first column is zero instead move the pivot one to the right
        while (i < rows && j < columns) {
            //Swap the row with the row that has the largest absolute jth value
            //This is done because dividing by small values may cause issues with precision
            swap(output[i], output[output.elements[i..rows].maxIndex!((T[columns] a, T[columns] b) => abs(a[j]) < abs(b[j])) + i]);
            //If the maximum is zero, then the entire column is equal to zero and we need to move the pointer right
            if (output[i][j] == 0) {
                j += 1;
            }
            //Makes the pivot entry equal to one
            output[i][] /= output[i][j];
            //Set all elements below the pivot to zero
            foreach (row; 0..rows) {
                if (row == i) continue; 
                output[row][] -= output[i][] * output[row][j];
            }
            i += 1;
            j += 1;
        }
        return output;
    }
    /**
     * The transpose operation returns the matrix 'flipped' about its diagonal - 
     * That is, rows and columns are switched
     */
    @property Matrix!(T, columns, rows) transpose() {
        Matrix!(T, columns, rows) output = new Matrix!(T, columns, rows)(0);
        foreach (i; 0..columns) {
            output.setRow(i, this.getColumn(i));
        }
        return output;
    }

    /**
     * Constructs a matrix from a two-dimensional array of elements
     * TODO: Handle improper dimensions
     */
    this(T[][] elements) {
        foreach (i, row; elements) {
            foreach (j, element; row) {
                this.elements[i][j] = element;
            }
        }
    }

    /**
     * Constructs a matrix that is identically one value
     */
    this(T element) {
        T[columns][rows] elements = element;
        this.elements[] = elements;
    }

    /**
     * Constructs a matrix as an identity matrix
     */
    this() {
        T[columns][rows] elements = 0;
        //TODO: Can be more efficient with parallelism?
        foreach (i; 0..min(rows, columns)) {
            elements[i][i] = 1;
        }
        this.elements = elements;
    }

    /**
     * Copy constructor for a matrix; creates a copy of the given matrix
     */
    this(Matrix!(T, rows, columns) toCopy) {
        this(toCopy.elements.to!(T[][]));
    }

    /**
     * Sets the nth row of the matrix
     */
    void setRow(uint index, Vector!(T, columns) r) {
        this.elements[index] = r.components;
    }

    /**
     * Returns the nth row of the matrix
     */
    Vector!(T, columns) getRow(uint index) {
        return new Vector!(T, columns)(this.elements[index]);
    }

    /**
     * Sets the nth column of the matrix
     */
    void setColumn(uint index, Vector!(T, rows) c) {
        foreach (i, ref row; this.elements) {
            row[index] = c[i];
        }
    }

    /**
     * Returns the nth column of the matrix
     */
    Vector!(T, rows) getColumn(uint index) {
        Vector!(T, rows) c = new Vector!(T, rows)();
        foreach (i, row; this.elements) {
            c[i] = row[index];
        }
        return c;
    }

    /**
     * Returns a rectangular slice of the matrix with the upper left corner at the specified location
     * and a specified size
     * Usable to get rows and columns; just set the height or width to 1
     */
    Matrix!(T, height, width) getSlice(uint height, uint width)(uint startRow, uint startColumn) {
        Matrix!(T, height, width) output = new Matrix!(T, height, width)(0);
        assert(startRow + height <= rows && startColumn + width <= columns, "Matrix: Slice out of bounds: " ~ (startRow+height).to!string ~ "," ~ (startColumn + width).to!string ~ " > " ~ rows.to!string ~ "," ~ columns.to!string);
        foreach (i; 0..height) {
            output.elements[i] = this.elements[startRow + i][startColumn .. startColumn + width];
        }
        return output;
    }

    /**
     * Allows assigning the matrix to a static two-dimensional array to set all components of the matrix
     */
    void opAssign(T[][] rhs) {
        foreach (i, row; rhs) {
            foreach (j, element; row) {
                this.elements[i][j] = element;
            }
        }
    }

    /**
     * Allows assigning the matrix to a static two-dimensional array to set all components of the matrix
     */
    void opAssign(T[columns][rows] rhs) {
        this.elements = rhs;
    }

    /**
     * Allows assigning the matrix to a single value to set all elements of the matrix to such a value
     */
    void opAssign(T rhs) {
        T[columns] row = rhs;
        this.elements[] = row;
    }

    /**
     * Multiplication of a matrix by a vector
     * This is essentially a matrix multiplication, but is handled separately for convenience
     * If Vector is made to extend Matrix in the future, this will become obsolete 
     */
    Vector!(T, rows) opBinary(string op)(Vector!(T, rows) other) {
        static if (op == "*") {
            Vector!(T, rows) output = new Vector!(T, rows)();
            foreach (i; 0..rows) {
                output[i] = dot!(T, rows)(other, this.getRow(i));
            }
            return output;
        }
        assert(0, "Matrix: Operation not supported...");
    }

    /**
     * Pairwise operations on matrices
     * Addition: Adds all elements
     * Multiplication: Mulitplies all elements - this is known as the Hadamard Product
     * etc.
     */
    Matrix!(T, rows, columns) opBinary(string op)(Matrix!(T, rows, columns) other) {
        Matrix!(T, rows, columns) output = new Matrix!(T, rows, columns)(this);
        foreach (index, ref component; output.elements[].parallel()) {
            mixin("output.elements[index][] " ~ op ~ "= other.elements[index][];");
        }
        return output;
    }

    /**
     * Pairwise operations on matrices with a constant
     */
    Matrix!(T, rows, columns) opBinary(string op)(T constant) {
        Matrix!(T, rows, columns) output = new Matrix!(T, rows, columns)(this);
        foreach (index, ref component; output.elements[].parallel()) {
            mixin("output.elements[index][] " ~ op ~ "= constant;");
        }
        return output;
    }

    /**
     * Returns the matrix as a string
     */
    override string toString() {
        return "\n" ~ this.elements.to!(T[][])
            .map!(a => a.to!string ~ "\n")
            .reduce!((string a, string b) => a ~ b);
    }

}

/**
 * Takes the product of two matrices with a shared dimension
 */
Matrix!(T, rows1, columns2) multiply
                                (T, uint rows1, uint columns2, uint sharedDimension)
                                (Matrix!(T, rows1, sharedDimension) lhs, Matrix!(T, sharedDimension, columns2) rhs) {
    Matrix!(T, rows1, columns2) output = new Matrix!(T, rows1, columns2)(0);
    //TODO: Could be sped up by parallelism
    foreach (i; 0..rows1) {
        foreach (j; 0..columns2) {
            output[i][j] = dot!(T, sharedDimension)(lhs.getRow(i), rhs.getColumn(j));
        }
    } 
    return output;
}

/**
 * Returns an augmented matrix consisting of two matrices with the same number of rows
 * Useful for inverse calculations and solving linear systems of equations
 */
Matrix!(T, rows, columns1 + columns2) augment
                                        (T, uint rows, uint columns1, uint columns2)
                                        (Matrix!(T, rows, columns1) lhs, Matrix!(T, rows, columns2) rhs) {
    Matrix!(T, rows, columns1 + columns2) output = new Matrix!(T, rows, columns1 + columns2);
    foreach (i; 0..rows) {
        output.setRow(i, new Vector!(T, columns1 + columns2)(lhs.elements[i] ~ rhs.elements[i]));
    }
    return output;
} 

/**
 * Returns a rotation matrix for a given radian input
 * A rotation matrix is a matrix that, when multiplied by the column vector of a given point, rotates that point counterclockwise by the given angle
 */
Matrix!(double, 2, 2) rotationMatrixOf(double theta) {
    /* Creates an array that is
     * [ [cos(theta), -sin(theta)],
     *   [sin(theta),  cos(theta)] ]
     * which are the rows of a 2D rotation matrix that rotates counterclockwise by theta */
    return new Matrix!(double, 2, 2)([[cos(theta), -sin(theta)], [sin(theta), cos(theta)]]);
}
