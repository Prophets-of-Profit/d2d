module d2d.math.AxisAlignedBoundingBox;

import std.math;
import std.parallelism;
import std.traits;
import d2d.math.Segment;
import d2d.math.Vector;

/**
 * A rectangle is a box in 2d space
 * Because these rectangles are axis aligned, they don't have any rotation
 * TODO: make this class dimension agnostic currently only works for 2d
 */
class AxisAlignedBoundingBox(T, ulong dimensions) {

    Vector!(T, dimensions) initialPoint; ///The initial or starting point of the AABB
    Vector!(T, dimensions) extent; ///The extent in each direction the AABB extends from the initial point (eg.)

    /**
     * Gets all the vertices of the AABB
     */
    @property Vector!(T, dimensions)[] vertices() {
        //TODO:
    }

    /**
     * Gets all the edges of the AABB
     */
    @property Segment!(T, dimensions)[] edges() {
        //TODO:
    }

    /**
     * Creates an AABB from the initial point, and how much in each direction the box extends
     */
    this(Vector!(T, dimensions) initialPoint, Vector!(T, dimensions) extent) {
        this.initialPoint = initialPoint;
        this.extent = extent;
    }

    /**
     * Returns whether the box contains the given point
     * TODO: untested and doesn't account for whether extent is negative
     */
    bool contains(Vector!(T, dimensions) point) {
        bool contains = true;
        foreach(i, ref component; (cast(T[]) point.components).parallel) {
            if (component < this.initialPoint.components[i] || component > this.initialPoint.components[i] + this.extent.components[i]) {
                contains = false;
            }
        }
        return contains;
    }

}

/**
 * Returns whether two rectangles intersect
 */
bool intersects(T, U)(AxisAlignedBoundingBox!T rect1, AxisAlignedBoundingBox!U rect2) {
    //TODO:
}
