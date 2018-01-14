module d2d.math.Vector;

import std.algorithm;
import std.array;
import std.math;
import std.parallelism;

/**
 * A vector is an object representing distance in vertical and horizontal directions in multidimensional space
 * Components are the first template parameter with the second template parameter being vector dimensionality
 * Vectors currently don't support swizzling
 * TODO: slice operators (and opCall?)
 */
class Vector(T, ulong dimensions) {

    T[] components; ///The components of the vector

    /**
     * If the vector is at least 1-dimensional, makes x a viable property method
     */
    static if (dimensions > 0) {
        @property void x(T value) {
            this.components[0] = value;
        }

        @property T x() {
            return this.components[0];
        }
    }

    /**
     * If the vector is at least 2-dimensional, makes y a viable property method
     */
    static if (dimensions > 1) {
        @property void y(T value) {
            this.components[1] = value;
        }

        @property T y() {
            return this.components[1];
        }
    }

    /**
     * If the vector is at least 3-dimensional, makes z a viable property method
     */
    static if (dimensions > 2) {
        @property void z(T value) {
            this.components[2] = value;
        }

        @property T z() {
            return this.components[2];
        }
    }

    /**
     * Sets the angles of the vector where the angles are given in radians
     * Angles are direction angles (eg. first angle is direction from x, second is direction from y, etc...)
     * 0 goes along the positive axis
     */
    @property void directionAngles(Vector!(T, dimensions) angles) {
        //TODO: write this
    }

    /**
     * Gets the angles of the vector where the angles are given in radians
     * Angles are direction angles (eg. first angle is direction from x, second is direction from y, etc...)
     * 0 goes along the positive axis
     */
    @property Vector!(T, dimensions) directionAngles() {
        return new Vector!(T, dimensions)();
    }

    /**
     * Sets the length of the vector
     * Maintains component ratios of the vector
     */
    @property void magnitude(double mag) {
        immutable scale = mag / this.magnitude;
        foreach (component; this.components.parallel) {
            component = cast(T)(component * scale);
        }
    }

    /**
     * Gets the length of the vector
     */
    @property double magnitude() {
        return sqrt(cast(double) this.components.reduce!((squareMag,
                component) => squareMag + component.pow(2)));
    }

    /**
     * A vector constructor; takes in the number of args given and assigns them as components
     */
    this(T[] components...) {
        assert(components.length == dimensions);
        this.components = components;
    }

    /**
     * A vector constructor; takes in a value that acts as both vector components
     */
    this(T allComponents) {
        foreach (component; this.components.parallel) {
            component = allComponents;
        }
    }

    /**
     * Allows assigning the vector to a static array to set all components of the vector
     */
    void opAssign(T[] rhs) {
        this.components = rhs;
    }

    /**
     * Allows assigning the vector to a single value to set all elements of the vector to such a value
     */
    void opAssign(T rhs) {
        foreach (component; this.components.parallel) {
            component = rhs;
        }
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise (eg. (3, 2, 1) += (1, 2, 3) makes (3, 2, 1) into (4, 4, 4))
     */
    void opOpAssign(string op)(Vector!(T, dimensions) otherVector) {
        foreach (index, ref component; this.components.parallel) {
            mixin("component " ~ op ~ "= otherVector.components[index];");
        }
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise, so each operation of the constant is applied to each component
     */
    void opOpAssign(string op)(T[] otherComponents) {
        foreach (index, ref component; this.components.parallel) {
            mixin("component " ~ op ~ "= otherComponents[index];");
        }
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise, so each operation of the constant is applied to each component
     */
    void opOpAssign(string op)(T constant) {
        foreach (index, ref component; this.components.parallel) {
            mixin("component " ~ op ~ "= constant;");
        }
    }

    /**
     * Allows unary functions to be applied to the vector; aplies the same operator to all components
     */
    Vector!(T, dimensions) opUnary(string op)() {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        foreach (ref component; newVec.components.parallel) {
            mixin("component = " ~ op ~ "component;");
        }
        return newVec;
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise (eg. (3, 2, 1) + (1, 2, 3) = (4, 4, 4))
     */
    Vector!(T, dimensions) opBinary(string op)(Vector!(T, dimensions) otherVector) {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        foreach (index, component; newVec.components.parallel) {
            mixin("component " ~ op ~ "= otherVector.components[index];");
        }
        return newVec;
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise (eg. (3, 2, 1) + (1, 2, 3) = (4, 4, 4))
     */
    Vector!(T, dimensions) opBinary(string op)(T[] otherComponents) {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        foreach (index, ref component; newVec.components.parallel) {
            mixin("component " ~ op ~ "= otherComponents[index];");
        }
        return newVec;
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise, so each operation of the constant is applied to each component
     */
    Vector!(T, dimensions) opBinary(string op)(T constant) {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        foreach (index, ref component; newVec.components.parallel) {
            mixin("component " ~ op ~ "= constant;");
        }
        return newVec;
    }

}

/**
 * Calculates the dot product or the similarity of two vectors
 */
T dot(T)(Vector!T first, Vector!T second) {
    immutable pairWiseMultiple = first * second;
    return pairWiseMultiple.components.sum;
}

//TODO: implement cross product

/**
 * Returns whether two segments defined by (initial, terminal, initial, terminal) intersect
 * TODO: untested and explain how it works
 */
bool doSegmentsIntersect(T, U)(Vector!(T, 2) firstInitial, Vector!(T,
        2) firstTerminal, Vector!U secondInitial, Vector!U secondTerminal) {
    immutable firstDelta = firstTerminal - firstInitial;
    immutable secondDelta = secondTerminal - secondInitial;
    double dotproduct = cast(double)(firstDelta.x * secondDelta.x + firstDelta.y * secondDelta.y) / (
            firstDelta.magnitude * secondDelta.magnitude);
    if (dotproduct == 1 || dotproduct == -1) {
        return firstDelta == secondDelta;
    }
    immutable firstIntersection = -(((secondInitial.x - firstInitial.x) * secondDelta.y) - (
            (secondInitial.y - firstInitial.y) * secondDelta.x)) / (
            (secondDelta.x * firstDelta.y) - (secondDelta.y * firstDelta.x));
    immutable secondIntersection = -(((firstInitial.x - secondInitial.x) * firstDelta.y) - (
            (firstInitial.y - secondInitial.y) * firstDelta.x)) / (
            (firstDelta.x * secondDelta.y) - (firstDelta.y * secondDelta.x));
    return firstIntersection >= 0 && secondIntersection >= 0
        && firstIntersection <= 1 && secondIntersection <= 1;
}

alias iVector = Vector!(int, 2);
alias dVector = Vector!(double, 2);
alias fVector = Vector!(float, 2);
