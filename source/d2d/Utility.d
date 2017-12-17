module d2d.Utility;

import std.math;
import d2d.sdl2;

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
 * A point is a location in 2d space
 * Location is accessed by x and y coordinates
 * Can also sometimes act as a position vector
 * TODO overload operators
 */
class Point(T) if (__traits(isScalar, T)) {

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
     * Sets the angle of the point relative to (0, 0)
     * Angles are in radians where right is 0 and up is pi / 2
     */
    @property void angle(double a) {
        double mag = this.magnitude;
        this.x = cast(T)(mag * cos(a));
        this.y = cast(T)(mag * sin(a));
    }

    /**
     * Gets the angle of the point relative to (0, 0)
     * Angles are in radians where right is 0 and up is pi / 2
     */
    @property double angle() {
        return atan2(0.0 + this.y, 0.0 + this.x);
    }

    /**
     * Sets the distance from this point to (0, 0)
     */
    @property void magnitude(double mag) {
        double scalar = mag / this.magnitude;
        this.x = cast(T)(this.x * scalar);
        this.y = cast(T)(this.y * scalar);
    }

    /**
     * Gets the distance from this point to (0, 0)
     */
    @property double magnitude() {
        return sqrt(0.0 + this.x * this.x + this.y * this.y);
    }

    /**
     * A point constructor; takes in an x value and a y value
     */
    this(T x, T y) {
        this.x = x;
        this.y = y;
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
     * Gets the rectangle as an SDL_Rect
     */
    @property SDL_Rect* handle() {
        sdlRectangle = SDL_Rect(cast(int) this.x, cast(int) this.y,
                cast(int) this.w, cast(int) this.h);
        return &sdlRectangle;
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
    bool contains(U)(Point!U point) {
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

alias iPoint = Point!int;
alias dPoint = Point!double;
alias fPoint = Point!float;
alias iRectangle = Rectangle!int;
alias dRectangle = Rectangle!double;
alias fRectangle = Rectangle!float;
