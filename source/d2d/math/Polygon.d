module d2d.math.Polygon;

import d2d.math.Vector;

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

alias iPolygon = Polygon!int;
alias dPolygon = Polygon!double;
alias fPolygon = Polygon!float;
