module d2d.math.Polygon;

import d2d.math.Vector;

/**
 * A polygon is a solid object defined by its vertices
 * T is the type of the polygon, dimensions is in how many dimensions; sides is how many sides the polygon has
 * TODO: rename?
 */
class Polygon(T, ulong dimensions, ulong sides) {

    Vector!(T, dimensions)[sides] vertices; ///The vertices of the polygon

    //TODO: add more polygon constructors

    /**
     * Creates a polygon using a list of vertices as vertices
     */
    this(Vector!(T, dimensions)[sides] vertices) {
        assert(vertices.length > 2);
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

alias iPolygon(T) = Polygon!(int, 2, T);
alias dPolygon(T) = Polygon!(double, 2, T);
alias fPolygon(T) = Polygon!(float, 2, T);
