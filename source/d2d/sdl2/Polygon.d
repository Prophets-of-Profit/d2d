/**
 * Polygon
 */
module d2d.sdl2.Polygon;

import std.algorithm;
import std.array;
import std.parallelism;
import std.range;
import std.traits;
import d2d.math.AxisAlignedBoundingBox;
import d2d.math.Segment;
import d2d.math.Vector;

/**
 * A polygon is an object defined by its vertices in 2 space
 * T is the type of the polygon and sides is how many sides the polygon has
 * TODO: upgrade to dimension-ambiguous model class in math
 */
class Polygon(T, uint numSides) {

    Vector!(T, 2)[numSides] vertices; ///The vertices of the polygon

    /**
     * Gets the sides of a polygon
     */
    @property Segment!(T, 2)[numSides] sides() {
        Segment!(T, 2)[numSides] s;
        foreach (i; iota(0, cast(uint) numSides).parallel) {
            s[i] = new Segment!(T, 2)(this.vertices[i], this.vertices[(i + 1) % $]);
        }
        return s;
    }

    /**
     * Creates an empty polygon
     */
    this() {}

    /**
     * Creates a polygon using a list of vertices as vertices
     */
    this(Vector!(T, 2)[] vertices...) {
        assert(vertices.length == numSides);
        this.vertices = vertices;
    }

    /**
     * Casts the polygon to a polygon of another type
     */
    U opCast(U)() if (is(U : Polygon!V, V...)) {
        alias type = TemplateArgsOf!U[0];
        return new U(cast(Vector!(type, 2)[]) this.vertices);
    }

    /**
     * Returns whether or not a given point is inside the polygon
     * This algorithm uses scanlining (see Renderer.fillPolygon) 
     * Conceptually, it draws a ray to the left from the given point; if the ray intersects the polygon an odd number of times
     * the point is within the polygon
     */
    bool contains(U)(Vector!(U, 2) point) {
        Segment!(T, 2)[] relevantSides = (cast(Segment!(T, 2)[]) this.sides).filter!(
                a => (a.initial.y - point.y) * (a.terminal.y - point.y) <= 0).array;
        int intersections;
        foreach (side; relevantSides) {
            immutable dy = point.y - side.initial.y;
            immutable intersection = (dy * side.direction.x + side.initial.x * side.direction.y) / side
                .direction.y;
            if (intersection < point.x) {
                intersections++;
            }
        }
        return intersections % 2 == 1;
    }

}

/**
 * Returns the rectangle bounding a polygon
 */
AxisAlignedBoundingBox!(T, 2) bound(T, uint sides)(Polygon!(T, sides) toBound) {
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
    return new AxisAlignedBoundingBox!(T, 2)(minVals.x, minVals.y,
            maxVals.x - minVals.x, maxVals.y - minVals.y);
}

alias iPolygon(uint T) = Polygon!(int, T);
alias dPolygon(uint T) = Polygon!(double, T);
alias fPolygon(uint T) = Polygon!(float, T);
