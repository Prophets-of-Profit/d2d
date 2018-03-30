module d2d.math.BezierCurve;

import d2d.math.Vector;

/**
 * A class that represents a Bezier Curve
 * Supposedly the most visually appealing curves
 * Needs a lot of complicated math; this class doesn't have much functionality other than what one might need to draw it
 */
class BezierCurve(T, uint dimensions) {

    Vector!(T, dimensions)[] controlPoints; ///The points that control the path of the curve; usually don't actually exist on curve

    /**
     * Gets numPoints amount of points that are on the bezier curve evenly spaced from the beginning point to the end point (t 0 => 1)
     */
    Vector!(T, dimensions)[numPoints] getPoints(uint numPoints)() {
        Vector!(T, dimensions)[numPoints] containedPoints;
        enum tStep = 1.0 / (numPoints + 1);
        foreach (pointNumber; 0 .. numPoints) {
            Vector!(double, dimensions)[] tempVals;
            foreach (point; this.controlPoints) {
                tempVals ~= cast(Vector!(double, dimensions)) point;
            }
            for (uint i = cast(uint) this.controlPoints.length - 1; i > 0; i--) {
                foreach (j; 0 .. i) {
                    tempVals[j] += (tempVals[j + 1] - tempVals[j]) * (pointNumber * tStep);
                }
            }
            containedPoints[pointNumber] = cast(Vector!(T, dimensions)) tempVals[0];
        }
        return containedPoints;
    }

    /**
     * Creates a bezier curve given a list of control points
     */
    this(Vector!(T, dimensions)[] cPoints...) {
        this.controlPoints = cPoints;
    }

}
