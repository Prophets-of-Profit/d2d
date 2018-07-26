module d2d.sdl2.ShapeDrawer;

import std.algorithm;
import std.conv;
import d2d.math;
import d2d.sdl2;

/**
 * A utility class to provide math drawing utilities
 */
abstract class ShapeDrawer {

    /**
     * Sets the color that the ShapeDrawer will draw at
     */
    @property void drawColor(Color color);

    /**
     * Gets the color that the ShapeDrawer will draw at
     */
    @property Color drawColor();

    protected double rotation = 0.0; // Value for how much each point will be rotated by in radians

    protected double[2] pointOfRotation = [0.0, 0.0];  // The point that rotated points will be rotated about

    /**
     * Shape drawer needs only one fundamental draw methods to be defined:
     * point, which all other shape drawer fill and draw methods use
     * Other methods below can be overridden if there exists more efficient sdl method
     */
    void drawPoint(int x, int y);

    /**
     * Draws a point rotated about the given "pointOfRotation" and rotated clockwise by the the amount of radians specified in "rotation"
     */
    void drawPointRotated(int x, int y) {
        Matrix!(double, 3, 1) translatedPoint = multiply!(double, 3, 1, 3)(translationMatrixOf(-1*this.pointOfRotation[0], -1*this.pointOfRotation[1]), new Matrix!(double, 3, 1)([[to!double(x)], [to!double(y)], [1.0]]));
        Matrix!(double, 2, 1) rotatedPoint = multiply!(double, 2, 1, 2)(rotationMatrixOf(this.rotation), translatedPoint.getSlice!(2, 1)(0, 0));
        Matrix!(double, 3, 1) finalPoint = multiply!(double, 3, 1, 3)(translationMatrixOf(this.pointOfRotation[0], this.pointOfRotation[1]), new Matrix!(double, 3, 1)([[rotatedPoint.elements[0][0]], [rotatedPoint.elements[1][0]], [1.0]]));
        drawPoint(to!int(finalPoint.elements[0][0]), to!int(finalPoint.elements[1][0]));
    }

    /**
     * Performs a draw function but rotates each point by the specified rotation given in radians clockwise around the specified point
     */
    void drawRotated(void delegate() action, double rotationNew, double xcoord, double ycoord) {
        this.rotation = rotationNew;
        this.pointOfRotation = [xcoord, ycoord];
        action();
        this.rotation = 0.0;
        this.pointOfRotation = [0.0, 0.0];
    }


    /**
     * Draws a line
     * Can be overridden
     */
    void drawLine(iVector first, iVector second) {
        iVector difference = second - first;
        immutable slope = cast(double)difference.y / cast(double)difference.x;
        foreach (x; first.x .. second.x + 1) {
            this.draw(x, cast(int)(first.y + slope * cast(double)(x - first.x)));
        }
    }

    /**
     * Draws the outlines of a rectangle
     * Can be overridden
     */
    void drawRect(iRectangle rect) {
        foreach (edge; rect.edges) {
            this.draw(edge);
        }
    }

    /**
     * Fills in a rectangle
     * Can be overridden
     */
    void fillRect(iRectangle rect) {
        int[2] xBounds = [rect.initialPoint.x, rect.bottomRight.x];
        foreach (y; rect.initialPoint.y .. rect.bottomRight.y + 1) {
            this.draw(new iVector(xBounds[0], y), new iVector(xBounds[1], y));
        }
    }

    /**
     * Internally used function that performs an action with a certain color
     */
    private void performWithColor(void delegate() action, Color color) {
        immutable oldColor = this.drawColor;
        this.drawColor = color;
        action();
        this.drawColor = oldColor;
    }

    /**
     * Draws a point to the screen
     * Just calls the basic draw point method
     */
    void draw(int x, int y) {
        this.drawPointRotated(x, y);
    }

    /**
     * Draws a point to the screen
     */
    void draw(int x, int y, Color color) {
        this.performWithColor({ this.draw(x, y); }, color);
    }

    /**
     * Draws a point given by a vector
     */
    void draw(iVector point) {
        this.draw(point.x, point.y);
    }

    /**
     * Draws a point given by a vector
     */
    void draw(iVector point, Color color) {
        this.performWithColor({ this.draw(point); }, color);
    }

    /**
     * Draws a line given by two points
     */
    void draw(iVector first, iVector second) {
        this.drawLine(first, second);
    }

    /**
     * Draws a line given by two points
     */
    void draw(iVector first, iVector second, Color color) {
        this.performWithColor({ this.draw(first, second); }, color);
    }

    /**
     * Draws a line given by a segment
     */
    void draw(iSegment line) {
        this.draw(line.initial, line.terminal);
    }

    /**
     * Draws a line given by a segment
     */
    void draw(iSegment line, Color color) {
        this.performWithColor({ this.draw(line); }, color);
    }

    /**
     * Draws the given rectangle
     */
    void draw(iRectangle rect) {
        this.drawRect(rect);
    }

    /**
     * Draws the given rectangle
     */
    void draw(iRectangle rect, Color color) {
        this.performWithColor({ this.draw(rect); }, color);
    }

    /**
     * Fills the given rectangle
     */
    void fill(iRectangle rect) {
        this.fillRect(rect);
    }

    /**
     * Fills the given rectangle
     */
    void fill(iRectangle rect, Color color) {
        this.performWithColor({ this.fill(rect); }, color);
    }

    /**
     * Draws the given bezier curve with numPoints number of points on the curve
     * More points is smoother but slower
     */
    void draw(uint numPoints = 100)(BezierCurve!(int, 2) curve) {
        Vector!(int, 2)[numPoints] points = (curve.getPoints!numPoints);
        foreach (i; 0 .. points.length - 1) {
            this.draw(points[i], points[i + 1]);
        }
    }

    /**
     * Draws the given bezier curve with numPoints number of points on the curve
     * More points is smoother but slower
     */
    void draw(uint numPoints = 100)(BezierCurve!(int, 2) curve, Color color) {
        this.performWithColor({ this.draw!numPoints(curve); }, color);
    }

    /**
     * Draws a polygon
     */
    void draw(uint sides)(iPolygon!sides toDraw) {
        foreach (polygonSide; toDraw.sides) {
            this.draw(polygonSide);
        }
    }

    /**
     * Draws a polygon
     */
    void draw(uint sides)(iPolygon!sides toDraw, Color color) {
        this.performWithColor({ this.draw!sides(toDraw); }, color);
    }

    /**
     * Fills a polygon
     * Uses scanlining
     */
    void fill(uint sides)(iPolygon!sides toDraw) {
        iRectangle bounds = bound(toDraw);
        int[][int] intersections; //Stores a list of x coordinates of intersections accessed by the y value
        foreach (polygonSide; toDraw.sides) {
            foreach (y; bounds.initialPoint.y .. bounds.bottomLeft.y) {
                //Checks that the y value exists within the segment
                if ((y - polygonSide.initial.y) * (y - polygonSide.terminal.y) > 0) {
                    continue;
                }
                //If the segment is a horizontal line at this y, draws the horizontal line and then breaks
                if (y == polygonSide.initial.y && polygonSide.initial.y == polygonSide.terminal.y) {
                    this.draw(polygonSide.initial, polygonSide.terminal);
                    continue;
                }
                //Vertical lines
                if (polygonSide.initial.x == polygonSide.terminal.x) {
                    intersections[y] ~= polygonSide.initial.x;
                    continue;
                }
                //Finds the intersection of the horizontal y = line with the polygon side using point slope form of a line
                iVector sideDirection = polygonSide.direction;
                immutable dy = y - polygonSide.initial.y;
                intersections[y] ~= (dy * sideDirection.x + polygonSide.initial.x * sideDirection.y) / sideDirection
                    .y;

            }
        }
        foreach (y, xValues; intersections) {
            foreach (i; 0 .. xValues.sort.length - 1) {
                this.draw(new iVector(xValues[i], y), new iVector(xValues[i + 1], y));
            }
        }
    }

    /**
     * Fills a polygon
     * Uses scanlining
     */
    void fill(uint sides)(iPolygon!sides toDraw, Color color) {
        this.performWithColor({ this.fill!sides(toDraw); }, color);
    }

    /**
     * Draws the ellipse bounded by the given box between the given angles in radians
     * More points generally means a slower but more well drawn ellipse
     */
    void draw(uint numPoints = 100)(iRectangle bounds, double startAngle, double endAngle) {
        immutable angleStep = (endAngle - startAngle) / numPoints;
        iVector previousPoint;
        iVector currentPoint = new iVector(-1);
        foreach (i; 0 .. numPoints + 1) {
            immutable currentAngle = startAngle + angleStep * i;
            currentPoint.x = cast(int)(bounds.extent.x * cos(currentAngle) / 2);
            currentPoint.y = cast(int)(bounds.extent.y * sin(currentAngle) / 2);
            currentPoint += bounds.center;
            if (previousPoint !is null) {
                draw(previousPoint, currentPoint);
            }
            previousPoint = new iVector(currentPoint);
        }
    }

    /**
     * Draws the ellipse bounded by the given box between the given angles in radians
     * More points generally means a slower but more well drawn ellipse
     */
    void draw(uint numPoints = 100)(iRectangle bounds, double startAngle,
            double endAngle, Color color) {
        this.performWithColor({
            this.draw!numPoints(bounds, startAngle, endAngle);
        }, color);
    }

    /**
     * Fills the ellipse bounded by the given box between the given angles in radians
     * Fills the ellipse between the arc endpoints: fills ellipse as arc rather than filling as ellipse (not a pizza slice)
     * More points generally means a slower but more well drawn ellipse
     */
    void fill(uint numPoints = 100)(iRectangle bounds, double startAngle, double endAngle) {
        immutable angleStep = (endAngle - startAngle) / numPoints;
        iPolygon!numPoints ellipseSlice = new iPolygon!numPoints();
        foreach (i; 0 .. numPoints) {
            immutable currentAngle = startAngle + angleStep * i;
            ellipseSlice.vertices[i] = bounds.center + new iVector(
                    cast(int)(bounds.extent.x * cos(currentAngle) / 2),
                    cast(int)(bounds.extent.y * sin(currentAngle) / 2));
        }
        this.fill!numPoints(ellipseSlice);
    }

    /**
     * Fills the ellipse bounded by the given box between the given angles in radians
     * Fills the ellipse between the arc endpoints: fills ellipse as arc rather than filling as ellipse (not a pizza slice)
     * More points generally means a slower but more well drawn ellipse
     */
    void fill(uint numPoints = 100)(iRectangle bounds, double startAngle,
            double endAngle, Color color) {
        this.performWithColor({
            this.fill!numPoints(bounds, startAngle, endAngle);
        }, color);
    }

}
