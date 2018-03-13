module d2d.math.AxisAlignedBoundingBox;

import std.algorithm;
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
     * Gives the AABB convenient 2d aliases
     */
    static if (dimensions == 2) {
        alias x = initialPoint.x;
        alias y = initialPoint.y;
        alias w = extent.x;
        alias h = extent.y;
        //TODO: whether these properties work is unkown and the indices as of right now were chosen arbitrarily: TEST!!!!
        @property Vector!(T, 2) topLeft() { return this.vertices[0]; }
        @property Vector!(T, 2) topRight() { return this.vertices[1]; }
        @property Vector!(T, 2) bottomLeft() { return this.vertices[3]; }
        @property Vector!(T, 2) bottomRight() { return this.vertices[2]; }
    }

    /**
     * Gets all the vertices of the AABB
     * TODO: this is really bad and probably doesn't work
     */
    @property Vector!(T, dimensions)[] vertices() {
        Vector!(T, dimensions)[] allVerts;
        if (this.extent == new Vector!(T, dimensions)(0)) {
            return [this.initialPoint];
        }
        foreach (component; this.extent.components) {
            foreach (i; 0..dimensions) {
                AxisAlignedBoundingBox!(T, dimensions) copy = new AxisAlignedBoundingBox!(T, dimensions)(new Vector!(T, dimensions)(this.initialPoint.components), new Vector!(T, dimensions)(this.extent.components));
                if (copy.extent.components[i] == 0) {
                    continue;
                }
                copy.initialPoint.components[i] += copy.extent.components[i];
                copy.extent.components[i] = 0;
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
        return null;
    }

    /**
     * Gets the point that is the middle or center of the AABB
     */
    @property Vector!(T, dimensions) center() {
        return this.initialPoint + this.extent / 2;
    }

    /**
     * Creates an AABB from the initial point, and how much in each direction the box extends
     */
    this(Vector!(T, dimensions) initialPoint, Vector!(T, dimensions) extent) {
        this.initialPoint = initialPoint;
        this.extent = extent;
    }

    /**
     * Creates an AABB from the same as the vector constructor, but as a varargs input
     */
    this(T[] args...) {
        this.initialPoint = new Vector!(T, dimensions)(0);
        this.extent = new Vector!(T, dimensions)(0);
        foreach (i; 0..dimensions) {
            this.initialPoint.components[i] = args[i];
            this.extent.components[i] = args[i + dimensions];
        }
    }

    /**
     * Returns whether the box contains the given point
     * TODO: untested
     */
    bool contains(Vector!(T, dimensions) point) {
        return false;
    }

}

/**
 * Returns whether two rectangles intersect
 * TODO: replace: doesn't work
 */
bool intersects(T, U)(AxisAlignedBoundingBox!T rect1, AxisAlignedBoundingBox!U rect2) {
    return false;
}
