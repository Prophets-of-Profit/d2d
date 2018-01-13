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

/**
 * A list of pre-defined common colors
 */
enum PredefinedColor {
    RED = Color(255, 0, 0),
    GREEN = Color(0, 255, 0),
    BLUE = Color(0, 0, 255),
    YELLOW = Color(255, 255, 0),
    MAGENTA = Color(255, 0, 255),
    CYAN = Color(0, 255, 255),
    WHITE = Color(255, 255, 255),
    PINK = Color(255, 125, 255),
    ORANGE = Color(255, 125, 0),
    LIGHTGREY = Color(175, 175, 175),
    DARKGREY = Color(75, 75, 75),
    BLACK = Color(0, 0, 0)
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
     * Makes a rectangle given top left coordinates as a vector and width and height
     */
    this(Vector!T topLeft, T w, T h) {
        this.x = topLeft.x;
        this.y = topLeft.y;
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

alias iRectangle = Rectangle!int;
alias dRectangle = Rectangle!double;
alias fRectangle = Rectangle!float;
