module d2d.math.Vector;

import std.algorithm;
import std.array;
import std.conv;
import std.math;
import std.parallelism;
import std.traits;

/**
 * A vector is an object representing distance in vertical and horizontal directions in multidimensional space
 * Components are the first template parameter with the second template parameter being vector dimensionality
 * Most vector operations take advantage of parallelism to do simple arithmetic on each component in parallel
 * TODO: slice operators, swizzling, and dispatch forwarding and vectorizing more of these operations?
 */
class Vector(T, ulong dimensions) {

    ///The components of the vector
    union {
        T[dimensions] components;
        struct {
            static if (dimensions > 0) {
                T x;
            }
            static if (dimensions > 1) {
                T y;
            }
            static if (dimensions > 2) {
                T z;
            }
            static if (dimensions > 3) {
                T w;
            }
        }
    }

    /**
     * Sets the angles of the vector where the angles are given in radians
     * Angles are direction angles (eg. first angle is direction from x, second is direction from y, etc...)
     * 0 goes along the positive axis
     */
    @property void directionAngles(Vector!(double, dimensions) angles) {
        immutable mag = this.magnitude;
        foreach (i, angle; (cast(double[]) angles.components).parallel) {
            this.components[i] = cast(T)(mag * cos(angle));
        }
    }

    /**
     * Gets the angles of the vector where the angles are given in radians
     * Angles are direction angles (eg. first angle is direction from x, second is direction from y, etc...)
     * 0 goes along the positive axis
     */
    @property Vector!(double, dimensions) directionAngles() {
        Vector!(double, dimensions) angles = new Vector!(double, dimensions)(cast(T) 0);
        immutable mag = this.magnitude;
        foreach (i, component; (cast(T[]) this.components).parallel) {
            angles.components[i] = acos(component / mag);
        }
        return angles;
    }

    /**
     * Sets the length of the vector
     * Maintains component ratios of the vector
     */
    @property void magnitude(double mag) {
        immutable scale = mag / this.magnitude;
        foreach (i, ref component; (cast(T[]) this.components).parallel) {
            component = cast(T)(component * scale);
        }
    }

    /**
     * Gets the length of the vector
     */
    @property double magnitude() {
        return sqrt(cast(double) reduce!((squareMag,
                component) => squareMag + component.pow(2))(cast(T) 0, this.components));
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
        this.components[] = allComponents;
    }

    /**
     * A copy constructor for a vector; makes the same vector, but as a different instance
     */
    this(Vector!(T, dimensions) toCopy) {
        this.components[] = toCopy.components[];
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
        this.components[] = rhs;
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise (eg. (3, 2, 1) += (1, 2, 3) makes (3, 2, 1) into (4, 4, 4))
     */
    void opOpAssign(string op)(Vector!(T, dimensions) otherVector) {
        mixin("this.components[] " ~ op ~ "= otherVector.components[];");
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise, so each operation of the constant is applied to each component
     */
    void opOpAssign(string op)(T[] otherComponents) {
        mixin("this.components[] " ~ op ~ "= otherComponents[];");
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise, so each operation of the constant is applied to each component
     */
    void opOpAssign(string op)(T constant) {
        mixin("this.components[] " ~ op ~ "= constant;");
    }

    /**
     * Casts the vector to a vector of another type
     */
    U opCast(U)() if (is(U : Vector!V, V...)) {
        alias type = TemplateArgsOf!U[0];
        U newVec = new U(type.init);
        foreach (i, component; (cast(T[]) this.components).parallel) {
            newVec.components[i] = cast(type) component;
        }
        return newVec;
    }

    /**
     * Allows unary functions to be applied to the vector; aplies the same operator to all components
     */
    Vector!(T, dimensions) opUnary(string op)() {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        mixin("newVec.components[] = " ~ op ~ "newVec.components[];");
        return newVec;
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise (eg. (3, 2, 1) + (1, 2, 3) = (4, 4, 4))
     */
    Vector!(T, dimensions) opBinary(string op)(Vector!(T, dimensions) otherVector) {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        mixin("newVec.components[] " ~ op ~ "= otherVector.components[];");
        return newVec;
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise (eg. (3, 2, 1) + (1, 2, 3) = (4, 4, 4))
     */
    Vector!(T, dimensions) opBinary(string op)(T[] otherComponents) {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        mixin("newVec.components[] " ~ op ~ "= otherComponents[];");
        return newVec;
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise, so each operation of the constant is applied to each component
     */
    Vector!(T, dimensions) opBinary(string op)(T constant) {
        Vector!(T, dimensions) newVec = new Vector(this.components);
        mixin("newVec.components[] " ~ op ~ "= constant;");
        return newVec;
    }

    /**
     * Gives the vector a pretty string format
     * (eg. (1, 2, 3) => <1, 2, 3>)
     */
    override string toString() {
        string representation = "<";
        foreach (i; 0 .. this.components.length) {
            representation ~= this.components[i].to!string;
            representation ~= (i + 1 != this.components.length) ? ", " : ">";
        }
        return representation;
    }

    /**
     * Returns whether the vector is equal to another vector or constant
     * Uses approxEquals to do easy equality for vectors of doubles
     */
    override bool opEquals(Object o) {
        bool isEqual = true;
        Vector!(T, dimensions) cmp = cast(Vector!(T, dimensions)) o;
        foreach(i, ref component; (cast(T[]) this.components).parallel) {
            if (!approxEqual(component, cmp.components[i])) {
                isEqual = false;
            }
        }
        return isEqual;
    }

}

/**
 * Calculates the dot product or the similarity of two vectors
 */
T dot(T, ulong dim)(Vector!(T, dim) first, Vector!(T, dim) second) {
    immutable pairWiseMultiple = first * second;
    return pairWiseMultiple.components.sum;
}

/**
 * Calculates the cross product or the perpendicular vector to two vectors
 * Currently only works on 2 or 3 dimensional vectors
 */
Vector!(T, 3) cross(T, ulong size)(Vector!(T, size) first, Vector!(T, size) second)
        if (size == 2 || size == 3) {
    static if (size == 2) {
        return new Vector!(T, 3)(0, 0, first.x * second.y - first.y * second.x);
    }
    return new Vector!(T, 3)(first.y * second.z - first.z * second.y,
            first.z * second.x - first.x * second.z, first.x * second.y - first.y * second.x);
}
