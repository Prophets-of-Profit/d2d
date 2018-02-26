module d2d.math.AxisAlignedBoundingBox;

import std.math;
import std.traits;
import d2d.math.Vector;

/**
 * A rectangle is a box in 2d space
 * Because these rectangles are axis aligned, they don't have any rotation
 * TODO: make this class dimension agnostic currently only works for 2d
 */
class AxisAlignedBoundingBox(T, ulong dimensions) {

    T x; ///The top left x coordinate of the rectangle
    T y; ///The top left y coordinate of the rectangle
    T w; ///The rectangle's width
    T h; ///The rectangle's height

    /** 
     * Gets the coordinates of the top left corner of the rectangle 
     */
    @property Vector!(T, 2) topLeft() {
        return new Vector!(T, 2)(this.x, this.y);
    }

    /** 
     * Gets the coordinates of the bottom left corner of the rectangle 
     */
    @property Vector!(T, 2) bottomLeft() {
        return new Vector!(T, 2)(this.x, this.y + this.h);
    }

    /** 
     * Gets the coordinates of the top right corner of the rectangle 
     */
    @property Vector!(T, 2) topRight() {
        return new Vector!(T, 2)(this.x + this.w, this.y);
    }

    /** 
     * Gets the coordinates of the bottom right corner of the rectangle 
     */
    @property Vector!(T, 2) bottomRight() {
        return new Vector!(T, 2)(this.x + this.w, this.y + this.h);
    }

    /**
     * Gets the coordinates of the center of the rectangle
     */
    @property Vector!(T, 2) center() {
        return new Vector!(T, 2)(this.x + this.w / 2, this.y + this.h / 2);
    }

    /**
     * Gets the dimensions of the rectangle
     */
    @property Vector!(T, 2) dimensions() {
        return new Vector!(T, 2)(this.w, this.h);
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
     * Casts the rectangle to a rectangle of another type
     */
    U opCast(U)() if (is(U : AxisAlignedBoundingBox!(V, dimensions), V...)) {
        alias type = TemplateArgsOf!U[0];
        return new U(cast(type) this.x, cast(type) this.y, cast(type) this.w, cast(type) this.h);
    }

    /**
     * Returns whether this rectangle contains the given point
     */
    bool contains(U)(Vector!(U, 2) point) {
        return point.x > this.x && point.x < this.x + this.w && point.y > this.y
            && point.y < this.y + this.h;
    }

    /**
     * Returns whether this rectangle completely contains the other rectangle
     */
    bool contains(U)(AxisAlignedBoundingBox!(U) other) {
        return this.x < other.x && this.y < other.y && this.x + this.w > other.x + other.w && this.y + this.h > other.y + other.h;
    }

    /**
     * Gives the rectangle as a pretty string
     */
    override string toString() {
        return "AxisAlignedBoundingBox[<x, y> = " ~ this.topLeft.toString ~ "; <w, h> = " ~ this.dimensions.toString ~ "]";
    }

}

/**
 * Returns whether two rectangles intersect
 */
bool intersects(T, U)(AxisAlignedBoundingBox!T rect1, AxisAlignedBoundingBox!U rect2) {
    return rect1.x < rect2.x + rect2.w && rect1.x + rect1.w > rect2.x
        && rect1.y < rect2.y + rect2.h && rect1.h + rect1.y > rect2.y;
}
