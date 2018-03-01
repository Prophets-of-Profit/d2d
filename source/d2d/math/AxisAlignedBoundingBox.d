module d2d.math.AxisAlignedBoundingBox;

import std.math;
import std.parallelism;
import std.traits;
import d2d.math.Segment;
import d2d.math.Vector;

/**
 * A rectangle is a box in 2d space
 * Because these rectangles are axis aligned, they don't have any rotation
 */
class AxisAlignedBoundingBox(T, ulong dimensions) {

    Vector!(T, dimensions) initialPoint; ///The initial or starting point of the AABB
    Vector!(T, dimensions) extent; ///The extent in each direction the AABB extends from the initial point (eg.)

    /**
     * Gets all the vertices of the AABB
     * TODO: this is really bad and probably doesn't work
     */
    @property Vector!(T, dimensions)[] vertices() {
        Vector!(T, dimensions)[] allVerts;
        if (this.extent == 0) {
            return [this.initialPoint];
        }
        foreach (i, component; this.extent) {
            foreach (i; 0..dimensions) {
                AxisAlignedBoundingBox!(T, dimensions) copy = AxisAlignedBoundingBox!(T, dimensions)(new Vector!(T, dimensions)(this.initialPoint.components), new Vector!(T, dimensions)(this.extent.components));
                copy.initialPoint[i] += copy.extent[i];
                copy.extent[i] = 0;
                foreach (vertex; copy.vertices) {
                    if (!allVerts.canFind(vertex)) {
                        allVerts ~= vertex;
                    }
                }
            }
        }
        return allVerts;
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
     * TODO: untested
     */
    bool contains(Vector!(T, dimensions) point) {
        bool contains = true;
        foreach(i, ref component; (cast(T[]) point.components).parallel) {
            if ((component < this.initialPoint.components[i] || component > this.initialPoint.components[i] + this.extent.components[i]) && (component > this.initialPoint.components[i] || component < this.initialPoint.components[i] + this.extent.components[i])) {
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
    bool contains;
    foreach(vertex; rect1.vertices) {
        if (rect2.contains(vertex)) {
            contains = true;
        }
    }
    return contains;
}
