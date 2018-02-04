module d2d.math.Polygon;

import std.parallelism;
import std.range;
import d2d.math.Segment;
import d2d.math.Vector;

/**
 * A polygon is a solid object defined by its vertices
 * T is the type of the polygon, dimensions is in how many dimensions; sides is how many sides the polygon has
 * TODO: rename or move to SDL?
 */
class Polygon(T, ulong dimensions, ulong numSides) {

    Vector!(T, dimensions)[numSides] vertices; ///The vertices of the polygon

    /**
     * Gets the sides of a polygon
     */
    @property Segment!(T, dimensions)[numSides] sides() {
        Segment!(T, dimensions)[numSides] s;
        foreach (i; iota(0, numSides).parallel) {
            s[i] = new Segment!(T, dimensions)(this.vertices[i], this.vertices[(i + 1) % $]);
        }
        return s;
    }

    /**
     * Creates a polygon using a list of vertices as vertices
     */
    this(Vector!(T, dimensions)[] vertices...) {
        assert(vertices.length == numSides);
        this.vertices = vertices;
    }

    /**
     * Returns whether or not a given point is inside the polygon
     * TODO: untested and explain how it works
     */
    bool contains(U)(Vector!(U, dimensions) point, int boundary = 2500) {
        int intersectionCount;
        Vector!(U, dimensions) leftBound = new Vector!(U, dimensions)(cast(U) 0, point.y);
        Vector!(U, dimensions) rightBound = new Vector!(U, dimensions)(cast(U) boundary, point.y);
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

alias iPolygon(ulong T) = Polygon!(int, 2, T);
alias dPolygon(ulong T) = Polygon!(double, 2, T);
alias fPolygon(ulong T) = Polygon!(float, 2, T);
