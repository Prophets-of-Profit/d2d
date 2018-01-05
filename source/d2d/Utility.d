module d2d.Utility;

import std.math;
import d2d.sdl2;

//TODO: move into separate math module

/**
 * A color struct
 * As of right now, only works with additive RGBA, but may work with other formats later
 * Additive RGBA is where the color is stored as an addition of red, green, and blue
 * Alpha is the transparency of the color
 */
struct Color {
    ubyte r; ///Red value for the color
    ubyte g; ///Green value for the color
    ubyte b; ///Blue value for the color
    ubyte a = 255; ///Alpha value or transparency for the color
    private SDL_Color sdlColor;

    /**
     * Gets the color as an SDL_Color
     */
    @property SDL_Color* handle() {
        sdlColor = SDL_Color(r, g, b, a);
        return &sdlColor;
    }
}

enum DefaultColor {
    RED=Color(255, 0, 0),
    GREEN=Color(0, 255, 0),
    BLUE=Color(0, 0, 255),
    YELLOW=Color(255, 255, 0),
    MAGENTA=Color(255, 0, 255),
    CYAN=Color(0, 255, 255),
    WHITE=Color(255, 255, 255),
    PINK=Color(255, 125, 255),
    ORANGE=Color(255, 125, 0),
    LIGHTGREY=Color(175, 175, 175),
    DARKGREY=Color(75, 75, 75),
    BLACK=Color(0, 0, 0)
}

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
     * Assigns a negation operator the vector
     * Negating a vector just turns it around and makes its components the opposite of what they are
     */
    Vector!T opUnary(string op)() if (op == "-") {
        return new Vector!T(-x, -y);
    }

    /**
     * Allows the vector components to be postincremented or postdecremented
     */
    Vector!T opUnary(string op)() if (op == "++" || op == "--") {
        mixin("return new Vector!T(x" ~ op ~ ", y" ~ op ~ ");");
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise (eg. (3, 2, 1) + (1, 2, 3) = (4, 4, 4))
     */
    Vector!T opBinary(string op)(Vector!T otherVector)
            if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%") {
        mixin("return new Vector!T(x" ~ op ~ "otherVector.x, y" ~ op ~ "otherVector.y);");
    }

    /**
     * Allows the vector to be used with normal operators
     * Works component-wise, so each operation of the constant is applied to each component
     */
    Vector!T opBinary(string op)(T constant)
            if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%") {
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

/**
 * Returns whether two segments defined by (initial, terminal, initial, terminal) intersect
 * TODO: untested and explain how it works
 */
bool doSegmentsIntersect(T, U)(Vector!T firstInitial, Vector!T firstTerminal,
        Vector!U secondInitial, Vector!U secondTerminal) {
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

/**
 * A polygon is a two-dimensional solid object
 * This polygon is defined by its vertices
 */
class Polygon(T) if (__traits(isScalar, T)) {

    Vector!T[] points; ///The vertices of the polygon

    /**
     * Creates a polygon using a list of points as vertices
     */
    this(Vector!T[] points) {
        this.points = points;
        assert(points.length > 2);
    }

    /**
     * Returns whether or not a given point is inside the polygon
     * TODO: untested and explain how it works
     */
    bool contains(U)(Vector!U point, int boundary = 2500) {
        int intersectionCount;
        Vector!U leftBound = new Vector!U(cast(U) 0, point.y);
        Vector!U rightBound = new Vector!U(cast(U) boundary, point.y);
        foreach (i; 0 .. this.points.length - 1) {
            if (doSegmentsIntersect(leftBound, rightBound, this.points[i], this.points[i + 1])) {
                intersectionCount++;
            }
        }
        if (doSegmentsIntersect(leftBound, rightBound, this.points[0], this.points[$ - 1])) {
            intersectionCount++;
        }
        return intersectionCount % 2 == 0;
    }

}

/**
 * A rectangle is a box in 2d space
 * This struct only does Axis Aligned Bounding Boxes (AABB) which don't have rotation
 */
class Rectangle(T) if (__traits(isScalar, T)) {

    private SDL_Rect sdlRectangle;
    T x; ///The top left x coordinate of the rectangle
    T y; ///The top left y coordinate of the rectangle
    T w; ///The rectangle's width
    T h; ///The rectangle's height

    /** 
     * Gets the coordinates of the top left corner of the rectangle 
     */
    @property Vector!T topLeft() {
        return new Vector!T(this.x, this.y);
    }

    /** 
     * Gets the coordinates of the bottom left corner of the rectangle 
     */
    @property Vector!T bottomLeft() {
        return new Vector!T(this.x, this.y + this.h);
    }

    /** 
     * Gets the coordinates of the top right corner of the rectangle 
     */
    @property Vector!T topRight() {
        return new Vector!T(this.x + this.w, this.y);
    }

    /** 
     * Gets the coordinates of the bottom right corner of the rectangle 
     */
    @property Vector!T bottomRight() {
        return new Vector!T(this.x + this.w, this.y + this.h);
    }

    /**
     * Gets the rectangle as an SDL_Rect
     */
    @property SDL_Rect* handle() {
        sdlRectangle = SDL_Rect(cast(int) this.x, cast(int) this.y,
                cast(int) this.w, cast(int) this.h);
        return &sdlRectangle;
    }

    /**
     * Allows the rectangle to be casted to a polygon
     */
    override Polygon opCast(T)() if (is(T == Polygon)) {
        return new Polygon!T([topLeft, topRight, bottomRight, bottomLeft]);
    }

    /**
     * Makes a rectangle given top left coordinates and a width and a height
     */
    this(T x, T y, T w, T h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    /**
     * Returns whether this rectangle contains the given point
     */
    bool contains(U)(Vector!U point) {
        return point.x > this.x && point.x < this.x + this.w && point.y > this.y
            && point.y < this.y + this.h;
    }

}

/**
 * Returns whether two rectangles intersect
 */
bool intersects(T, U)(Rectangle!T rect1, Rectangle!U rect2) {
    return rect1.x < rect2.x + rect2.w && rect1.x + rect1.w > rect2.x
        && rect1.y < rect2.y + rect2.h && rect1.h + rect1.y > rect2.y;
}

alias iVector = Vector!int;
alias dVector = Vector!double;
alias fVector = Vector!float;
alias iRectangle = Rectangle!int;
alias dRectangle = Rectangle!double;
alias fRectangle = Rectangle!float;
