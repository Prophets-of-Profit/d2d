module d2d.sdl2.Polygon;

import std.parallelism;
import std.range;
import d2d.sdl2.Rectangle;
import d2d.math.Segment;
import d2d.math.Vector;

/**
 * A polygon is an object defined by its vertices in 2 space
 * T is the type of the polygon and sides is how many sides the polygon has
 */
class Polygon(T, ulong numSides) {

    Vector!(T, 2)[numSides] vertices; ///The vertices of the polygon

    /**
     * Gets the sides of a polygon
     */
    @property Segment!(T, 2)[numSides] sides() {
        Segment!(T, 2)[numSides] s;
        foreach (i; iota(0, cast(uint)numSides).parallel) {
            s[i] = new Segment!(T, 2)(this.vertices[i], this.vertices[(i + 1) % $]);
        }
        return s;
    }

    /**
     * Creates a polygon using a list of vertices as vertices
     */
    this(Vector!(T, 2)[] vertices...) {
        assert(vertices.length == numSides);
        this.vertices = vertices;
    }

    /**
     * Returns whether or not a given point is inside the polygon
     * TODO: untested and explain how it works
     */
    bool contains(U)(Vector!(U, 2) point, int boundary = 2500) {
        int intersectionCount;
        Vector!(U, 2) leftBound = new Vector!(U, 2)(cast(U) 0, point.y);
        Vector!(U, 2) rightBound = new Vector!(U, 2)(cast(U) boundary, point.y);
        foreach (i; 0 .. this.vertices.length - 1) {
            if (doSegmentsIntersect(leftBound, rightBound, this.vertices[i], this.vertices[i + 1])) {
                intersectionCount++;
            }
        }
        if (doSegmentsIntersect(leftBound, rightBound, this.vertices[0], this.vertices[$ - 1])) {
            intersectionCount++;
        }
        return intersectionCount % 2 == 0;
    }

}

/**
 * Returns the rectangle bounding a polygon
 */
Rectangle!T bound(T, ulong sides)(Polygon!(T, sides) toBound) {
    Vector!(T, 2) minVals = new Vector!(T, 2)(T.max);
    Vector!(T, 2) maxVals = new Vector!(T, 2)(T.max + 1); //Causes an overflow to get small value
    foreach (vertex; toBound.vertices) {
        if (vertex.x < minVals.x) {
            minVals.x = vertex.x;
        }
        if (vertex.x > maxVals.x) {
            maxVals.x = vertex.x;
        }
        if (vertex.y < minVals.y) {
            minVals.y = vertex.y;
        }
        if (vertex.y > maxVals.y) {
            maxVals.y = vertex.y;
        }
    }
    return new Rectangle!T(minVals.x, minVals.y, maxVals.x - minVals.x, maxVals.y - minVals.y);
}

alias iPolygon(ulong T) = Polygon!(int, T);
alias dPolygon(ulong T) = Polygon!(double, T);
alias fPolygon(ulong T) = Polygon!(float, T);
