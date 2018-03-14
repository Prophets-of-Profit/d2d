module d2d.math.BezierCurve;

import d2d.math.Vector;

/**
 * A class that represents a Bezier Curve
 * Supposedly the most visually appealing curves
 * Needs a lot of complicated math; this class doesn't have much functionality other than what one might need to draw it
 */
class BezierCurve(T, ulong dimensions) {

    Vector!(T, dimensions)[] controlPoints; ///The points that control the path of the curve; usually don't actually exist on curve

    /**
     * Gets numPoints amount of points that are on the bezier curve evenly spaced from the beginning point to the end point (t 0 => 1)
     * TODO: untested
     */
    Vector!(T, dimensions)[numPoints] getPoints(uint numPoints)() {
        Vector!(T, dimensions)[numPoints] containedPoints = 0;
        for(t = 0.0; t < 1.0; t += 1.0 / numPoints) {
            foreach(i; 0..this.controlPoints.length) {
                foreach (j; 0..(this.controlPoints.length - i)) {
                    containedPoints[j] += t * (containedPoints[j + 1] - containedPoints[j]);
                }
            }
        }
        return containedPoints;
    }
}
