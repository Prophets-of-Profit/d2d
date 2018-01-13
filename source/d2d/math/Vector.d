module d2d.math.Vector;

import std.math;
import d2d.sdl2;

/**
 * A vector is an object representing distance in vertical and horizontal directions in 2d space
 * Location is accessed by x and y components
 * Can also act as a point, representing distance from (0, 0)
 * TODO overload operators
 */
class Vector(T) if (__traits(isScalar, T)) {

    private SDL_Point sdlPoint;
    T x; ///X value of the point
    T y; ///Y value of the point

    /**
     * Gets the point as an SDL_Point
     */
    @property SDL_Point* handle() {
        sdlPoint = SDL_Point(cast(int) this.x, cast(int) this.y);
        return &sdlPoint;
    }

    /**
     * Sets the angle of the vector
     * Angles are in radians where right is 0 and up is pi / 2
     */
    @property void angle(double a) {
        immutable mag = this.magnitude;
        this.x = cast(T)(mag * cos(a));
        this.y = cast(T)(mag * sin(a));
    }

    /**
     * Gets the angle of the vector 
     * Angles are in radians where right is 0 and up is pi / 2
     */
    @property double angle() {
        return atan2(0.0 + this.y, 0.0 + this.x);
    }

    /**
     * Sets the length of the vector
     * Maintains component ratios of the vector
     */
    @property void magnitude(double mag) {
        immutable scalar = mag / this.magnitude;
        this.x = cast(T)(this.x * scalar);
        this.y = cast(T)(this.y * scalar);
    }

    /**
     * Gets the length of the vector
     */
    @property double magnitude() {
        return sqrt(0.0 + this.x * this.x + this.y * this.y);
    }

    /**
     * A vector constructor; takes in an x value and a y value
     */
    this(T x, T y) {
        this.x = x;
        this.y = y;
    }

    /**
     * A vector constructor; takes in a value that acts as both vector components
     */
    this(T xy) {
        this.x = xy;
        this.y = xy;
    }

    /**
     * Allows assigning the vector to a single value to set all elements of the vector to such a value
     */
    void opAssign(T rhs) {
        this.x = rhs;
        this.y = rhs;
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise (eg. (3, 2, 1) += (1, 2, 3) makes (3, 2, 1) into (4, 4, 4))
     */
    void opOpAssign(string op)(Vector!T otherVector) {
        mixin("this.x " ~ op ~ "= otherVector.x");
        mixin("this.y " ~ op ~ "= otherVector.y");
    }

    /**
     * Allows the vector to have the joint operator assign syntax
     * Works component-wise, so each operation of the constant is applied to each component
     */
    void opOpAssign(string op)(T constant) {
        mixin("this.x " ~ op ~ "= constant");
        mixin("this.y " ~ op ~ "= constant");
    }

    /**
     * Allows unary functions to be applied to the vector; aplies the same operator to all components
     */
    Vector!T opUnary(string op)() {
        mixin("return new Vector!T(" ~ op ~ "x, " ~ op ~ "y);");
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise (eg. (3, 2, 1) + (1, 2, 3) = (4, 4, 4))
     */
    Vector!T opBinary(string op)(Vector!T otherVector) {
        mixin("return new Vector!T(x" ~ op ~ "otherVector.x, y" ~ op ~ "otherVector.y);");
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise, so each operation of the constant is applied to each component
     */
    Vector!T opBinary(string op)(T constant) {
        mixin("return new Vector!T(x" ~ op ~ "constant, y" ~ op ~ "constant);");
    }

}

/**
 * Calculates the dot product or the similarity of two vectors
 */
T dot(T)(Vector!T first, Vector!T second) {
    immutable pairWiseMultiple = first * second;
    return pairWiseMultiple.x + pairWiseMultiple.y;
}

alias iVector = Vector!int;
alias dVector = Vector!double;
alias fVector = Vector!float;
